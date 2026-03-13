#!/usr/bin/env python3
"""
Installation script.
"""

import argparse
import ctypes
import functools
import logging
import os
import pathlib
import shutil
import subprocess
import sys


def main():
    """
    Entry point.
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('-v', '--verbose', required=False, default=False, action='store_true', help='to show debug output')
    args = parser.parse_args()
    logging_level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(level=logging_level, format='%(levelname)-6s - %(message)s')
    results = install()
    failed_stages_count = 0
    for result in results:
        if result.was_executed:
            if result.was_successful:
                logging.info('%s', result)
            else:
                logging.warning('%s', result)
            for step_result in result.failed_results:
                logging.error('%s', step_result)
            for step_result in result.successful_results:
                logging.info('%s', step_result)
        else:
            logging.debug('Stage "%s" was not executed.', result.stage_description)
    return failed_stages_count


class PlatformPath:
    """
    A path that can take different values depending on the platform.

    The path will also be expanded.
    """

    def __init__(self, **platform_paths):
        self._platform_paths = platform_paths
        self._path = pathlib.Path(platform_paths.get(sys.platform, '')).expanduser() if sys.platform in platform_paths else None

    @property
    def platforms(self):
        """
        Return the supported platforms.
        """
        return sorted(self._platform_paths.keys())

    @property
    def is_valid(self):
        """
        Return true if the path is valid for the current platform.
        """
        return self._path is not None

    @property
    def value(self):
        """
        Return the path value.
        """
        if not self.is_valid:
            raise ValueError(f'Path is not valid for platform {sys.platform}, supported platforms: {self.platforms}')
        return self._path

    def with_platforms(self, *platforms):
        """
        Create a new PlatformPath with only the specified platforms.
        """
        return PlatformPath(**{platform: path for platform, path in self._platform_paths.items() if platform in platforms})

    def __bool__(self):
        """
        Return true if the path is valid for the current platform.
        """
        return self.is_valid

    def __getattr__(self, name):
        """
        Delegate attribute access to the underlying pathlib.Path object.
        """
        return getattr(self.value, name)

    def __str__(self):
        """
        Return the string representation of the path.
        """
        return str(self.value) if self.is_valid else ''

    def __truediv__(self, other):
        """
        Support the division operator to join paths.
        """
        return PlatformPath(**{platform: pathlib.Path(path) / other for platform, path in self._platform_paths.items()})


class Condition:
    """
    To evaluate a condition when a step should be run or not.
    """

    def __init__(self, condition_function, *, is_static: bool = False) -> None:
        self.condition_function = condition_function
        self.is_static = is_static
        self.last_result = self.condition_function() if is_static else None

    def __bool__(self) -> bool:
        """
        Evaluate the condition.
        """
        if not self.is_static or self.last_result is None:
            self.last_result = self.condition_function()
        return self.last_result

    def __and__(self, other):
        """
        Combine two conditions with AND.
        """
        return Condition(lambda: bool(self) and bool(other), is_static=self.is_static and other.is_static)

    def __or__(self, other):
        """
        Combine two conditions with OR.
        """
        return Condition(lambda: bool(self) or bool(other), is_static=self.is_static and other.is_static)

    @staticmethod
    def always():
        """
        Condition that is always true.
        """
        return Condition(lambda: True, is_static=True)

    @staticmethod
    def never():
        """
        Condition that is always false.
        """
        return Condition(lambda: False, is_static=True)

    @staticmethod
    def create_command_is_successful(command: str, *, is_static=False, expected_exit_code=0):
        """
        Create a condition that is true if the command is successful.
        """
        def run_command():
            """
            Run the command and return true if it is successful.
            """
            result = False
            exit_code = None
            try:
                exit_code = subprocess.call(command, shell=True, stdout=subprocess.PIPE)
            finally:
                if exit_code is not None:
                    result = exit_code == expected_exit_code
            return result
        return Condition(run_command, is_static=is_static)


@functools.lru_cache
def find_dotfiles_folder_path():
    """
    Return the path to the folder containing the dot files.
    """
    dotfiles_folder = pathlib.Path(__file__).resolve().parent
    logging.debug('The dot files folder is %s', dotfiles_folder)
    return dotfiles_folder


def create_config_link(source: pathlib.Path, destination: pathlib.Path, *, force_copy=False):
    """
    Create a link from the source path to the destination path.
    """
    try:
        effective_destination = destination / source.name if destination.is_dir() else destination
        parent_folder = effective_destination.parent
        if not parent_folder.exists():
            mkdir_result, mkdir_message = mkdir_config(parent_folder)
            if not mkdir_result:
                return False, mkdir_message
        symlink_available = sys.platform != 'win32' or running_as_admin()
        copy_file = force_copy or (effective_destination.is_file() and not effective_destination.is_symlink()) or not symlink_available
        if copy_file:
            if effective_destination.exists():
                effective_destination.unlink()
            shutil.copy2(source, effective_destination)
            return True, 'copied file'
        else:
            if effective_destination.is_symlink():
                if effective_destination.resolve() == source:
                    return True, 'link already exists'
                effective_destination.unlink()
            os.symlink(source, effective_destination)
            return True, 'created link'
    except Exception as ex:
        return False, str(ex)


def mkdir_config(path: pathlib.Path):
    """
    Create a folder including the parents if it does not exist.

    Return a tuple (successful: bool, message: str).
    """
    if path.exists():
        return True, 'Folder already exists'
    else:
        try:
            path.mkdir(parents=True, exist_ok=True)
            return True, 'Folder created'
        except Exception as ex:
            return False, str(ex)


def running_as_admin():
    """
    Check if the process is running as administrator.
    """
    try:
        is_admin = os.getuid() == 0
    except AttributeError:
        is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
    return is_admin


def resolve_path(path: pathlib.Path | PlatformPath | str) -> pathlib.Path | None:
    """
    Resolve a path that can be either a pathlib.Path, str or a PlatformPath.
    """
    if isinstance(path, PlatformPath):
        if path.is_valid:
            return path.value
        return None
    return pathlib.Path(path)


class InstallStepResult:
    """
    The result of a step.
    """

    INDENT = '  '

    def __init__(self, description, *, successful: bool, message: str = '') -> None:
        self.description = description
        self.successful = successful
        self.message = message
        self.steps = []
        self.indent_level = 1

    @property
    def failed(self):
        """
        Return true if the step failed.
        """
        return not self.successful

    def increment_indent_level(self, ref=1):
        """
        Increment the indent level for the step and its sub-steps.
        """
        self.indent_level = ref + 1
        for step in self.steps:
            step.increment_indent_level(self.indent_level)

    def add_step(self, step):
        """
        Add a sub-step result.
        """
        step.increment_indent_level(self.indent_level)
        self.steps.append(step)
        self.successful = self.successful and step.successful

    def __str__(self) -> str:
        lines = [f'{InstallStepResult.INDENT * self.indent_level} * {self.description} -> {"Ok" if self.successful else "failed"}: {self.message}']
        lines.extend(str(step) for step in self.steps)
        return '\n          '.join(lines)


class InstallStageResult:
    """
    The result of running a stage.
    """

    def __init__(self, stage_description) -> None:
        self.stage_description = stage_description
        self.step_results = []

    def add_step_result(self, step_result: InstallStepResult):
        """
        Add the result of a step.
        """
        self.step_results.append(step_result)

    @property
    def was_executed(self):
        """
        Return true if at least one step was executed.
        """
        return len(self.step_results) > 0

    @property
    def was_successful(self):
        """
        Return true if all the steps were successful.
        """
        return all(not step_result.failed for step_result in self.step_results)

    @property
    def successful_results(self):
        """
        Return a list with the successful results.
        """
        return [result for result in self.step_results if result.successful]

    @property
    def failed_results(self):
        """
        Return a list with the failed results.
        """
        return [result for result in self.step_results if result.failed]

    def __str__(self) -> str:
        if self.was_executed:
            if self.was_successful:
                return f'Stage "{self.stage_description}", all {len(self.step_results)} steps Ok.'
            return f'Stage "{self.stage_description}", {len(self.successful_results)} steps Ok, {len(self.failed_results)} failed.'
        return f'Stage {self.stage_description} was not executed.'


class InstallStep:
    """
    Basic install step, to be used as an interface.
    """

    def __init__(self, description: str, *, when=None) -> None:
        self.description = description
        self.when = when if when is not None else Condition.always()

    def __call__(self) -> InstallStepResult | None:
        """
        Run a step.
        """
        if self.condition():
            try:
                return self.run()
            except Exception as ex:
                return InstallStepResult(self.description, successful=False, message=str(ex))
        return None

    def condition(self) -> bool:
        """
        Evaluate the condition to run the step.
        """
        return bool(self.when) if self.when is not None else True

    def run(self) -> InstallStepResult:
        """
        Run the step.

        This method should be implemented by subclasses to perform the actual step operations.
        """
        raise NotImplementedError('InstallStep is an interface, please implement the run method.')


class CloneFileStep(InstallStep):
    """
    Clone a file from source to destination.
    """

    def __init__(self, description: str, source: pathlib.Path | PlatformPath, destination: pathlib.Path | PlatformPath, *, when=None, force_copy=False) -> None:
        def condition_function():
            """
            Condition function to check if both source and destination are valid for the current platform.
            """
            source_valid = bool(source)
            destination_valid = bool(destination)
            if when is not None:
                return source_valid and destination_valid and bool(when)
            return source_valid and destination_valid

        condition = Condition(condition_function, is_static=True)
        super().__init__(description, when=condition)
        source_path = resolve_path(source)
        destination_path = resolve_path(destination)
        self.source = find_dotfiles_folder_path() / source_path if source_path else None
        self.destination = destination_path
        self.force_copy = force_copy

    def run(self) -> InstallStepResult:
        """
        Run the step.
        """
        if not self.source or not self.destination:
            success, message = False, 'Invalid source or destination'
        else:
            success, message = create_config_link(self.source, self.destination, force_copy=self.force_copy)
        return InstallStepResult(self.description, successful=success, message=message)


class CloneFolderStep(InstallStep):
    """
    Clone a folder from source to destination.
    """

    def __init__(self, description: str, source: pathlib.Path | PlatformPath, destination: pathlib.Path | PlatformPath, *, when=None, pattern='**/*') -> None:

        def condition_function():
            """
            Condition function to check if both source and destination are valid for the current platform.
            """
            source_valid = bool(source)
            destination_valid = bool(destination)
            if when is not None:
                return source_valid and destination_valid and bool(when)
            return bool(source_valid and destination_valid)
        condition = Condition(condition_function, is_static=True)
        super().__init__(description, when=condition)
        source_path = resolve_path(source)
        destination_path = resolve_path(destination)
        self.source = find_dotfiles_folder_path() / source_path if source_path else None
        self.destination = destination_path
        self.pattern = pattern

    def run(self) -> InstallStepResult:
        """
        Run the step.
        """
        clone_folder_result = InstallStepResult(self.description, successful=True)
        if not self.source or not self.destination:
            clone_folder_result.successful = False
            clone_folder_result.message = 'Invalid source or destination'
            return clone_folder_result
        file_count = 0
        for item in self.source.glob(self.pattern):
            if item.is_file():
                relative_file_path = item.relative_to(self.source)
                dst_config_file = self.destination / relative_file_path
                file_result, file_message = create_config_link(item, dst_config_file)
                clone_file_result = InstallStepResult(f'clone file to {dst_config_file}', successful=file_result, message=file_message)
                clone_folder_result.add_step(clone_file_result)
                if file_result:
                    file_count += 1
                else:
                    clone_folder_result.message = f'Error cloning file {item}: {file_message} in {self.destination}'
                    return clone_folder_result
        clone_folder_result.message = f'cloned {file_count} files to {self.destination}'
        return clone_folder_result


class ExecCommandStep(InstallStep):
    """
    A step to execute a command.
    """

    def __init__(self, description: str, command: str, *, when=None) -> None:
        super().__init__(description, when=when)
        self.command = command

    def run(self) -> InstallStepResult:
        """
        Run the commad.
        """
        subprocess_result = subprocess.run(self.command, shell=True, capture_output=True, check=False)
        command_successful = subprocess_result.returncode == 0
        message = f'Exit code: {subprocess_result.returncode}'
        if subprocess_result.stdout:
            message = f'{message}, stdout: {subprocess_result.stdout.decode("utf-8")}'
        if not command_successful:
            message = f'{message}, stderr: {subprocess_result.stderr.decode("utf-8")}'
        return InstallStepResult(self.description, successful=command_successful, message=message)


class InstallSystemdUserTimerStep(InstallStep):
    """
    Install a systemd user timer.
    """

    TIMERS_FOLDER = 'home-services'

    def __init__(self, description: str, folder: str, *, when=None) -> None:
        has_systemd = Condition.create_command_is_successful('systemctl --version', is_static=True)
        super().__init__(description, when=has_systemd and when if when else has_systemd)
        self.source = find_dotfiles_folder_path() / InstallSystemdUserTimerStep.TIMERS_FOLDER / folder

    def run(self) -> InstallStepResult:
        """
        Add the user timer.
        """
        install_result = InstallStepResult(self.description, successful=True)
        systemd_user_path = pathlib.Path('~/.config/systemd/user').expanduser()
        timer_name = None
        for item in self.source.glob('*'):
            if item.is_file():
                destination = systemd_user_path / item.name if item.suffix in set(['.timer', '.service']) else pathlib.Path('~/bin').expanduser() / item.name
                file_result, file_message = create_config_link(item, destination)
                step_result = InstallStepResult(f'install systemd user timer file {item.name}', successful=file_result, message=file_message)
                install_result.add_step(step_result)
                if not file_result:
                    install_result.message = f'Error installing systemd user timer {item.name}: {file_message}'
                    break
                if item.suffix == '.timer':
                    timer_name = item.name
        if timer_name and install_result.successful:
            daemon_reload_result = subprocess.run('systemctl --user daemon-reload', shell=True, capture_output=True, check=False)
            daemon_reload_message = f'Exit code: {daemon_reload_result.returncode}, stdout: {daemon_reload_result.stdout.decode("utf-8")}, stderr: {daemon_reload_result.stderr.decode("utf-8")}'
            install_result.add_step(InstallStepResult('reload systemd user daemon',
                                                           successful=daemon_reload_result.returncode == 0,
                                                           message=daemon_reload_message))
            enable_timer_result = subprocess.run(f'systemctl --user enable --now {timer_name}', shell=True, capture_output=True, check=False)
            enable_timer_message = f'Exit code: {enable_timer_result.returncode}, stdout: {enable_timer_result.stdout.decode("utf-8")}, stderr: {enable_timer_result.stderr.decode("utf-8")}'
            install_result.add_step(InstallStepResult('enable and start systemd user timer',
                                                           successful=enable_timer_result.returncode == 0,
                                                           message=enable_timer_message))
            enable_timer_result = subprocess.run(f'systemctl --user enable --now {timer_name}', shell=True, capture_output=True, check=False)
        return install_result


class InstallConfigStage:
    """
    Represents installing the configuration for a program.
    """

    def __init__(self, description) -> None:
        self.description = description
        self.steps = []

    def add_step(self, step: InstallStep):
        """
        Add a step to run.
        """
        self.steps.append(step)

    def __call__(self, *, stop_at_first_error=True) -> InstallStageResult:
        """
        To run all the steps contained by the stage.
        """
        stage_result = InstallStageResult(self.description)
        for step in self.steps:
            if step.condition():
                step_result = step()
                stage_result.add_step_result(step_result)
                if stop_at_first_error and step_result.failed:
                    break
        return stage_result


def install():
    """
    Run the install operations.
    """
    stages = []
    # dot files
    install_single_dotfiles = InstallConfigStage('install single dotfiles')
    install_single_dotfiles.add_step(CloneFileStep('install .tmux.conf', pathlib.Path('.tmux.conf'), PlatformPath(linux='~/.tmux.conf', darwin='~/.tmux.conf')))
    install_single_dotfiles.add_step(CloneFileStep('install .ruff.toml', pathlib.Path('.ruff.toml'), PlatformPath(linux='~/.ruff.toml', darwin='~/.ruff.toml', win32='~/.ruff.toml')))
    stages.append(install_single_dotfiles)
    # vim configuration
    install_vim_stage = InstallConfigStage('install vim configuration')
    install_vim_stage.add_step(CloneFileStep('install vimrc', pathlib.Path('_vimrc'), PlatformPath(linux='~/_vimrc', darwin='~/_vimrc', win32='~/_vimrc')))
    install_vim_stage.add_step(CloneFileStep('install gvimrc', pathlib.Path('_gvimrc'), PlatformPath(linux='~/_gvimrc', darwin='~/_gvimrc', win32='~/_gvimrc')))
    dest_vim_extras_path = PlatformPath(linux='~/.vim/extras', darwin='~/.vim/extras', win32='~/vimfiles/extras')
    install_vim_stage.add_step(CloneFolderStep('install vim extras', pathlib.Path('vimextras'), dest_vim_extras_path))
    source_efm_path = pathlib.Path('efm-langserver')
    destination_efm_path = dest_vim_extras_path.with_platforms('linux', 'win32') / 'efm-langserver'
    install_vim_stage.add_step(CloneFileStep('install efm-langserver config file', source_efm_path / 'jq_filter.txt', destination_efm_path / 'jq_filter.txt'))
    source_efm_exe_path = PlatformPath(linux=source_efm_path / 'linux', win32=source_efm_path / 'win32')
    install_vim_stage.add_step(CloneFolderStep('install efm-langserver executables', source_efm_exe_path, destination_efm_path))
    stages.append(install_vim_stage)
    # neovim configuration
    neovim_dest_path = PlatformPath(linux='~/.config/nvim', darwin='~/.config/nvim', win32='~/AppData/Local/nvim')
    install_neovim_stage = InstallConfigStage('install neovim configuration')
    stages.append(install_neovim_stage)
    install_neovim_stage.add_step(CloneFolderStep('install neovim config files', pathlib.Path('.config/nvim'), neovim_dest_path))
    install_neovim_stage.add_step(CloneFolderStep('install neovide config',
                                                       pathlib.Path('neovide'),
                                                       PlatformPath(linux='~/.config/neovide', darwin='~/.config/neovide', win32='~/AppData/Roaming/neovide')))
    has_flatpak = Condition.create_command_is_successful('flatpak --version', is_static=True)
    add_wrapper_command = """#!/bin/bash
    mkdir -p ~/.var/app/dev.neovide.neovide/data/bin
    nvim_path=$(which nvim)
    echo -e "#!/usr/bin/env bash\nflatpak-spawn --host $nvim_path \\$@" > ~/.var/app/dev.neovide.neovide/data/bin/nvim
    chmod +x ~/.var/app/dev.neovide.neovide/data/bin/nvim
    """
    install_neovim_stage.add_step(ExecCommandStep('add neovim wrapper for flatpak', add_wrapper_command, when=has_flatpak))
    install_neovim_stage.add_step(CloneFileStep('install neovide config for flatpak',
                                                pathlib.Path('neovide/config.toml'),
                                                PlatformPath(linux='~/.var/app/dev.neovide.neovide/config/neovide/config.toml'), when=has_flatpak, force_copy=True))
    set_neovide_config = """#!/bin/bash
    echo -e "neovim-bin = '$HOME/.var/app/dev.neovide.neovide/data/bin/nvim'" >> ~/.var/app/dev.neovide.neovide/config/neovide/config.toml
    """
    install_neovim_stage.add_step(ExecCommandStep('add neovim config for flatpak', set_neovide_config, when=has_flatpak))
    # Local services
    install_local_services_stage = InstallConfigStage('install local services')
    stages.append(install_local_services_stage)
    has_sdkman = Condition(lambda: pathlib.Path('~/.sdkman').expanduser().exists(), is_static=True)
    install_local_services_stage.add_step(InstallSystemdUserTimerStep('install sdkman update timer', 'sdkman', when=has_sdkman))
    has_vs_code = Condition.create_command_is_successful('code --version', is_static=True)
    install_local_services_stage.add_step(InstallSystemdUserTimerStep('install vs code extensions update timer', 'vs-code', when=has_vs_code))
    results = [stage() for stage in stages]
    return results


if __name__ == '__main__':
    sys.exit(main())
