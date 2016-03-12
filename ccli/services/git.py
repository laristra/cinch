#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from ccli.base import Service
from ccli.services.git_drivers.process import *

#------------------------------------------------------------------------------#
# Git handler.
#------------------------------------------------------------------------------#

class CINCHGit(Service):

    #--------------------------------------------------------------------------#
    # Initialization.
    #--------------------------------------------------------------------------#

    def __init__(self, subparsers):

        """
        """

        # get a command-line parser
        self.parser = subparsers.add_parser('git',
            help='Service to manage git repositories.')

        self.parser.add_argument('-d', '--debug', action="store_true",
            help='Turn on extra debug information and do not clean' +
                'up temporaries.  Implies --verbose.')

        self.parser.add_argument('-v', '--verbose', action="store_true",
            help='Turn on verbose output.')

        self.parser.add_argument('config',
            help='The JSON configuration file specifying ' +
                'the git operations.')

        # set the callback for this sub-command
        self.parser.set_defaults(func=self.main)

    # __init__

    #--------------------------------------------------------------------------#
    # Main.
    #--------------------------------------------------------------------------#

    def main(self, args=None):

        """
        """

        process(args)

    # main

    #--------------------------------------------------------------------------#
    # Object factory for service creation.
    #--------------------------------------------------------------------------#

    class Factory:
        def create(self, subparsers): return CINCHGit(subparsers)

# class CINCHGit

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
