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
                logging.error('  %s', step_result)
            for step_result in result.successful_results:
                logging.info('  %s', step_result)
        else:
            logging.debug('Stage "%s" was not executed.', result.stage_description)
    return failed_stages_count


class NVimPaths:
    """
    Class to handle neovim paths.
    """

    def __init__(self, platform):
        self.platform = platform
        nvim_directory = '~/.config/nvim' if self.platform != 'win32' else '~/AppData/Local/nvim'
        self._path = pathlib.Path(nvim_directory).expanduser().resolve()

    @property
    def path(self):
        """
        Get the editor path in the platform.
        """
        return self._path

    @property
    def extras_path(self):
        """
        Path to the extras directory.
        """
        return self.path / 'extras'


class NeovidePaths:
    """
    Class to handle neovide paths.
    """

    def __init__(self, platform):
        self.platform = platform
        nvim_directory = '~/.config/neovide' if self.platform != 'win32' else '~/AppData/Roaming/neovide'
        self._path = pathlib.Path(nvim_directory).expanduser().resolve()

    @property
    def path(self):
        """
        Get the editor path in the platform.
        """
        return self._path


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


class InstallOperation:
    """
    Decorator for install operations.
    """

    def __init__(self, description, platforms):
        self.description = description
        self.selected_platforms = sorted(platforms)

    def __call__(self, func, *args, **kwargs):
        if sys.platform in self.selected_platforms:
            @functools.wraps(func)
            def inner():
                """
                Wrapper function.
                """
                logging.info('%s', self.description)
                return func(*args, **kwargs)
        else:
            @functools.wraps(func)
            def inner(*args, **kwargs):
                """
                Dummy function when the platform is not selected.
                """
        inner.platforms = self.selected_platforms
        return inner

    @staticmethod
    def is_valid(operation_func):
        """
        Return true if the function is a valid operation.
        """
        return sys.platform in getattr(operation_func, 'platforms', [])


@functools.lru_cache
def find_dotfiles_folder_path():
    """
    Return the path to the folder containing the dot files.
    """
    dotfiles_folder = pathlib.Path(__file__).resolve().parent
    logging.debug('The dot files folder is %s', dotfiles_folder)
    return dotfiles_folder


@InstallOperation('Install neovim configuration files', ['darwin', 'linux', 'win32'])
def operation_install_nvim():
    """
    Create the basic folder structure and link the files.
    """
    dotfiles_folder = find_dotfiles_folder_path()
    nvim_paths = NVimPaths(sys.platform)
    nvim_dotfiles_folder = dotfiles_folder / '.config_lua_neovim' / 'nvim'
    created_config_files = set()
    for item in nvim_dotfiles_folder.glob('**/*'):
        if item.is_file():
            src_config_file = item
            relative_file_path = item.relative_to(nvim_dotfiles_folder)
            dst_config_file = nvim_paths.path / relative_file_path
            create_config_link(src_config_file, dst_config_file)
            created_config_files.add(dst_config_file)
    for item in nvim_paths.path.glob('**/*.*'):
        if not item.is_symlink():
            continue
        if item not in created_config_files:
            logging.warning('Extra file %s, deleting', item)
            item.unlink()
    neovide_configs_folder = dotfiles_folder / pathlib.Path('neovide')
    neovide_paths = NeovidePaths(sys.platform)
    for item in neovide_configs_folder.glob('**/*.*'):
        if item.is_file():
            src_config_file = item
            relative_file_path = item.relative_to(neovide_configs_folder)
            dst_config_file = neovide_paths.path / relative_file_path
            create_config_link(src_config_file, dst_config_file)
            created_config_files.add(dst_config_file)
    # for item in (dotfiles_folder / 'vimextras').glob('*'):
    #     if item.is_file():
    #         extra_dest_path = nvim_paths.extras_path / item.name
    #         verbose_link(item, extra_dest_path)


def create_config_link(source: pathlib.Path, destination: pathlib.Path):
    """
    Create a link from the source path to the destination path.
    """
    try:
        effective_destination = destination / source.name if destination.is_dir() else destination
        if effective_destination.is_symlink():
            if effective_destination.exists() and effective_destination.resolve() == source:
                return True, f'link {effective_destination} already exists'
            effective_destination.unlink()
        if effective_destination.exists():
            if effective_destination.is_file():
                shutil.copy2(source, effective_destination)
                return True, f'copied {source} to {effective_destination}'
        elif not effective_destination.exists():
            parent_folder = effective_destination.parent
            mkdir_result, mkdir_message = mkdir_config(parent_folder)
            if not mkdir_result:
                return False, mkdir_message
            symlink_available = sys.platform != 'win32' or running_as_admin()
            if symlink_available:
                os.symlink(source, effective_destination)
                return True, f'linked {source} to {effective_destination}'
            shutil.copy2(source, effective_destination)
            return True, f'copied {source} to {effective_destination}'
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

    def __init__(self, description, *, successful: bool, message: str = '') -> None:
        self.description = description
        self.successful = successful
        self.message = message

    @property
    def failed(self):
        """
        Return true if the step failed.
        """
        return not self.successful

    def __str__(self) -> str:
        if self.successful:
            return f'* {self.description} -> Ok' + (f': {self.message}' if self.message else '')
        return f'* {self.description} -> failed: {self.message}'


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

    def __call__(self) -> InstallStepResult:
        """
        Run a step.
        """
        raise NotImplementedError('InstallStep is an interface, please implement the __call__ method.')

    def condition(self) -> bool:
        """
        Evaluate the condition to run the step.
        """
        return bool(self.when) if self.when is not None else True


class CloneFileStep(InstallStep):
    """
    Clone a file from source to destination.
    """

    def __init__(self, description: str, source: pathlib.Path | PlatformPath, destination: pathlib.Path | PlatformPath, *, when=None) -> None:
        def condition_function():
            """
            Condition function to check if both source and destination are valid for the current platform.
            """
            source_valid = bool(source)
            destination_valid = bool(destination)
            return source_valid and destination_valid

        condition = Condition(condition_function, is_static=True)
        super().__init__(description, when=when and condition if when else condition)
        source_path = resolve_path(source)
        if source_path is None:
            raise ValueError('Source path is not valid or None.')
        destination_path = resolve_path(destination)
        if destination_path is None:
            raise ValueError('Destination path is not valid or None.')
        dot_files_folder = find_dotfiles_folder_path()
        self.source = dot_files_folder / source_path
        self.destination = destination_path

    def __call__(self) -> InstallStepResult:
        """
        Run the step.
        """
        try:
            success, message = create_config_link(self.source, self.destination)
            return InstallStepResult(self.description, successful=success, message=message)
        except Exception as ex:
            return InstallStepResult(self.description, successful=False, message=str(ex))


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
            return source_valid and destination_valid
        condition = Condition(condition_function, is_static=True)
        super().__init__(description, when=when and condition if when else condition)
        source_path = resolve_path(source)
        if source_path is None:
            raise ValueError('Source path is not valid or None.')
        destination_path = resolve_path(destination)
        if destination_path is None:
            raise ValueError('Destination path is not valid or None.')
        dot_files_folder = find_dotfiles_folder_path()
        self.source = dot_files_folder / source_path
        self.destination = destination_path
        self.pattern = pattern

    def __call__(self) -> InstallStepResult:
        """
        Run the step.
        """
        try:
            file_count = 0
            for item in self.source.glob(self.pattern):
                if item.is_file():
                    relative_file_path = item.relative_to(self.source)
                    dst_config_file = self.destination / relative_file_path
                    file_result, file_message = create_config_link(item, dst_config_file)
                    if file_result:
                        file_count += 1
                    else:
                        return InstallStepResult(self.description, successful=False, message=f'Error cloning file {item}: {file_message} in {self.destination}')
            return InstallStepResult(self.description, successful=True, message=f'cloned {file_count} files to {self.destination}')
        except Exception as ex:
            return InstallStepResult(self.description, successful=False, message=str(ex))


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
        if self.steps:
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
    install_vim_stage.add_step(CloneFileStep('install efm-langserver config file', source_efm_path / 'jq_filter.txt', dest_vim_extras_path.value / 'efm-langserver' / 'jq_filter.txt'))
    source_efm_exe_path = PlatformPath(linux=source_efm_path / 'linux', win32=source_efm_path / 'win32')
    install_vim_stage.add_step(CloneFolderStep('install efm-langserver executables', source_efm_exe_path, dest_vim_extras_path.value / 'efm-langserver'))
    stages.append(install_vim_stage)
    # neovim configuration
    neovim_dest_path = PlatformPath(linux='~/.config/nvim', darwin='~/.config/nvim', win32='~/AppData/Local/nvim')
    install_neovim_stage = InstallConfigStage('install neovim configuration')
    install_neovim_stage.add_step(CloneFolderStep('install neovim config files', pathlib.Path('.config_lua_neovim/nvim'), neovim_dest_path))
    stages.append(install_neovim_stage)
    install_neovim_stage.add_step(CloneFolderStep('install neovide config', pathlib.Path('neovide'), PlatformPath(linux='~/.config/neovide', darwin='~/.config/neovide', win32='~/AppData/Roaming/neovide')))
    results = [stage() for stage in stages]
    return results


if __name__ == '__main__':
    sys.exit(main())
