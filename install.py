#!/usr/bin/env python3
"""
Installation script.
"""

import argparse
import ctypes
import functools
import inspect
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
    # install()
    nvim_dest_path = PlatformPath(win32='~/.vimfiles', linux='~/.vim', darwin='~/.vim')
    assert nvim_dest_path.is_valid, f'Path is not valid for platform {sys.platform}, supported platforms: {nvim_dest_path.platforms}'
    logging.info('Neovim path: %s', nvim_dest_path)
    logging.info('Neovim path exists: %s', nvim_dest_path.exists())
    install_tmux_stage = InstallConfigStage('Install single dotfiles')
    install_tmux_stage.add_step(CloneFileStep('Install .tmux.conf', pathlib.Path('.tmux.conf'), PlatformPath(linux='~/.tmux.conf', darwin='~/.tmux.conf')))
    install_tmux_stage.add_step(CloneFileStep('Install .ruff.toml', pathlib.Path('.ruff.toml'), PlatformPath(linux='~/.ruff.toml', darwin='~/.ruff.toml', win32='~/.ruff.toml')))
    install_stage_result = install_tmux_stage()
    logging.info('Install stage result: %s', install_stage_result)
    return 0


def install():
    """
    Run the install operations.
    """
    for install_operation in list_install_operations():
        install_operation()


def list_install_operations():
    """
    Find the install operations.
    """
    def _is_operation_function(member):
        """
        Return True if the object is a function with the same name as the command.
        """
        return inspect.isfunction(member) and InstallOperation.is_valid(member)

    functions = inspect.getmembers(inspect.getmodule(list_install_operations), _is_operation_function)
    for _, operation_func in functions:
        yield operation_func


class VimPaths:
    """
    Class to handle vim paths.
    """

    def __init__(self, platform):
        self.platform = platform
        vim_directory = '~/.vim' if self.platform != 'win32' else '~/vimfiles'
        self._path = pathlib.Path(vim_directory).expanduser().resolve()

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
        self._path = pathlib.Path(platform_paths.get(sys.platform, '')).expanduser() if sys.platform in platform_paths else None
        self._platforms = sorted(platform_paths.keys())

    @property
    def platforms(self):
        """
        Return the supported platforms.
        """
        return list(self._platforms)

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


@InstallOperation('Install vim configuration files', ['linux', 'win32'])
def operation_install_vim():
    """
    Create the basic folder structure and link the files.
    """
    dotfiles_folder = find_dotfiles_folder_path()
    for filename in ('_vimrc', '_gvimrc'):
        src_vimrc = dotfiles_folder / filename
        dest_vimrc = pathlib.Path(f'~/{filename}').expanduser()
        verbose_link(src_vimrc, dest_vimrc)
    vim_paths = VimPaths(sys.platform)
    for item in (dotfiles_folder / 'vimextras').glob('*'):
        if item.is_file():
            extra_dest_path = vim_paths.extras_path / item.name
            verbose_link(item, extra_dest_path)


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
            verbose_link(src_config_file, dst_config_file)
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
            verbose_link(src_config_file, dst_config_file)
            created_config_files.add(dst_config_file)
    # for item in (dotfiles_folder / 'vimextras').glob('*'):
    #     if item.is_file():
    #         extra_dest_path = nvim_paths.extras_path / item.name
    #         verbose_link(item, extra_dest_path)


@InstallOperation('Install tmux configuration', ['darwin', 'linux'])
def operation_install_tmux():
    """
    Install tmux configuration.
    """
    dotfiles_folder = find_dotfiles_folder_path()
    src_config_file = dotfiles_folder / '.tmux.conf'
    dst_config_file = pathlib.Path('~/.tmux.conf').expanduser()
    verbose_link(src_config_file, dst_config_file)


@InstallOperation('Install ruff configuration', ['linux', 'win32'])
def operation_install_ruff():
    """
    Install tmux configuration.
    """
    dotfiles_folder = find_dotfiles_folder_path()
    src_config_file = dotfiles_folder / '.ruff.toml'
    dst_config_file = pathlib.Path('~/.ruff.toml').expanduser()
    verbose_link(src_config_file, dst_config_file)


@InstallOperation('Install efm-langserver', ['linux', 'win32'])
def operation_install_efm():
    """
    Install efm-langserver and the configuration file.
    """
    dotfiles_folder = find_dotfiles_folder_path()
    vim_paths = VimPaths(sys.platform)
    src_efm_folder = dotfiles_folder / 'efm-langserver'
    vim_efm_folder = vim_paths.extras_path / 'efm-langserver'
    src_efm_config_file = src_efm_folder / 'jq_filter.txt'
    for dst_folder in (vim_efm_folder, ):
        verbose_link(src_efm_config_file, dst_folder / src_efm_config_file.name)
    src_efm_exe_folder = src_efm_folder / sys.platform
    for item in src_efm_exe_folder.glob('*'):
        if item.is_file():
            vim_dest_path = vim_efm_folder / item.name
            verbose_link(item, vim_dest_path)


def verbose_link(source, destination):
    """
    Create a link from the source path to the destination path.
    """
    source_path = source.value if isinstance(source, PlatformPath) else pathlib.Path(source)
    if not source_path:
        raise ValueError('Source path is empty or None')
    destination_path = destination.value if isinstance(destination, PlatformPath) else pathlib.Path(destination)
    if not destination_path:
        raise ValueError('Destination path is empty or None')
    if destination_path.is_symlink():
        if destination_path.exists() and destination_path.resolve() == source_path:
            logging.debug('  link %s already exists', destination_path)
            return
        logging.info('Removing outdated symbolic link %s', destination_path)
        destination_path.unlink()
    if destination_path.exists() and destination_path.is_file():
        logging.info('  copying %s to %s', source_path, destination_path)
        shutil.copy2(source_path, destination_path)
    elif not destination_path.exists():
        parent_folder = destination_path.parent
        verbose_mkdir(parent_folder)
        symlink_available = sys.platform != 'win32' or running_as_admin()
        if symlink_available:
            logging.info('  linking %s to %s', source_path, destination_path)
            os.symlink(source_path, destination_path)
        else:
            logging.info('  copying %s to %s (Windows)', source_path, destination_path)
            shutil.copy2(source_path, destination_path)


def verbose_mkdir(path):
    """
    Create a folder including the parents if it does not exist.
    """
    if path.exists():
        logging.debug('  folder %s already exists', path)
    else:
        logging.info('  creating folder %s', path)
        path.mkdir(parents=True, exist_ok=True)


def running_as_admin():
    """
    Check if the process is running as administrator.
    """
    try:
        is_admin = os.getuid() == 0
    except AttributeError:
        is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
    return is_admin


class InstallStepResult:
    """
    The result of a step.
    """

    def __init__(self, description, *, successful: bool, error_message: str = '') -> None:
        self.description = description
        self.successful = successful
        self.error_message = error_message

    @property
    def failed(self):
        """
        Return true if the step failed.
        """
        return not self.successful

    def __str__(self) -> str:
        if self.successful:
            return f'Step "{self.description}" Ok.'
        return f'Step "{self.description}" failed: {self.error_message}'


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

    def __init__(self, description: str, source: pathlib.Path, destination: PlatformPath, *, when=None) -> None:
        super().__init__(description, when=when and destination.is_valid if when else destination.is_valid)
        dot_files_folder = find_dotfiles_folder_path()
        self.source = dot_files_folder / source
        self.destination = destination

    def __call__(self) -> InstallStepResult:
        """
        Run the step.
        """
        try:
            verbose_link(self.source, self.destination)
            return InstallStepResult(self.description, successful=True)
        except Exception as ex:
            return InstallStepResult(self.description, successful=False, error_message=str(ex))


class CloneFolderStep(InstallStep):
    """
    Clone a folder from source to destination.
    """

    def __init__(self, description: str, source: pathlib.Path | PlatformPath, destination: pathlib.Path | PlatformPath, *, when=None, pattern='**/*') -> None:
        common_platforms = set([sys.platform])
        if isinstance(source, PlatformPath):
            common_platforms &= set(source.platforms)
        if isinstance(destination, PlatformPath):
            common_platforms &= set(destination.platforms)
        super().__init__(description, when=when and Condition.valid_platform(common_platforms) if when else Condition.valid_platform(destination.platforms))
        dot_files_folder = find_dotfiles_folder_path()
        self.source = dot_files_folder / source
        self.destination = destination

    def __call__(self) -> InstallStepResult:
        """
        Run the step.
        """
        try:
            for item in self.source.glob('**/*'):
                if item.is_file():
                    relative_file_path = item.relative_to(self.source)
                    dst_config_file = self.destination / relative_file_path
                    verbose_link(item, dst_config_file)
            return InstallStepResult(self.description, successful=True)
        except Exception as ex:
            return InstallStepResult(self.description, successful=False, error_message=str(ex))


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
            logging.info('%s', self.description)
            for step in self.steps:
                if step.condition():
                    step_result = step()
                    logging.debug('Result of step %s: %s', step.description, step_result)
                    stage_result.add_step_result(step_result)
                    if stop_at_first_error and step_result.failed:
                        break
        return stage_result


if __name__ == '__main__':
    sys.exit(main())
