#!/usr/bin/env python3
"""
Installation script.
"""

import argparse
import functools
import inspect
import logging
import os
import pathlib
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
    install()
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


@functools.lru_cache()
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


@InstallOperation('Install neovim configuration files', ['linux', 'win32'])
def operation_install_nvim():
    """
    Create the basic folder structure and link the files.
    """
    dotfiles_folder = find_dotfiles_folder_path()
    nvim_paths = NVimPaths(sys.platform)
    nvim_dotfiles_folder = dotfiles_folder / '.config' / 'nvim'
    for item in nvim_dotfiles_folder.glob('**/*'):
        if item.is_file():
            src_config_file = item
            relative_file_path = item.relative_to(nvim_dotfiles_folder)
            dst_config_file = nvim_paths.path / relative_file_path
            verbose_link(src_config_file, dst_config_file)
    for item in (dotfiles_folder / 'vimextras').glob('*'):
        if item.is_file():
            extra_dest_path = nvim_paths.extras_path / item.name
            verbose_link(item, extra_dest_path)


@InstallOperation('Install tmux configuration', ['linux'])
def operation_install_tmux():
    """
    Install tmux configuration.
    """
    dotfiles_folder = find_dotfiles_folder_path()
    src_config_file = dotfiles_folder / '.tmux.conf'
    dst_config_file = pathlib.Path('~/.tmux.conf').expanduser()
    verbose_link(src_config_file, dst_config_file)


@InstallOperation('Install efm-langserver', ['linux', 'win32'])
def operation_install_efm():
    """
    Install efm-langserver and the configuration file.
    """
    dotfiles_folder = find_dotfiles_folder_path()
    nvim_paths = NVimPaths(sys.platform)
    vim_paths = VimPaths(sys.platform)
    src_efm_folder = dotfiles_folder / 'efm-langserver'
    vim_efm_folder = vim_paths.extras_path / 'efm-langserver'
    nvim_efm_folder = nvim_paths.extras_path / 'efm-langserver'
    src_efm_config_file = src_efm_folder / 'config.yaml'
    for dst_folder in (vim_efm_folder, nvim_efm_folder):
        verbose_link(src_efm_config_file, dst_folder / src_efm_config_file.name)
    src_efm_exe_folder = src_efm_folder / sys.platform
    for item in src_efm_exe_folder.glob('*'):
        if item.is_file():
            vim_dest_path = vim_efm_folder / item.name
            nvim_dest_path = nvim_efm_folder / item.name
            verbose_link(item, vim_dest_path)
            verbose_link(item, nvim_dest_path)


def verbose_link(source, destination):
    """
    Create a link from the source path to the destination path.
    """
    if destination.exists():
        logging.debug('  link %s already exists', destination)
    else:
        parent_folder = destination.parent
        verbose_mkdir(parent_folder)
        logging.info('  linking %s to %s', source, destination)
        os.link(source, destination)


def verbose_mkdir(path):
    """
    Create a folder including the parents if it does not exist.
    """
    if path.exists():
        logging.debug('  folder %s already exists', path)
    else:
        logging.info('  creating folder %s', path)
        path.mkdir(parents=True, exist_ok=True)


if __name__ == '__main__':
    sys.exit(main())
