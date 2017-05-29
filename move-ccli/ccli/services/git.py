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

        self.parser.add_argument('-o', '--operations', action="store_true",
            help='Show a description of the supported operations.')

        self.parser.add_argument('config', nargs='?',
            help='The JSON configuration file specifying ' +
                'the operations to perform.')

        # set the callback for this sub-command
        self.parser.set_defaults(func=self.main)

    # __init__

    #--------------------------------------------------------------------------#
    # Main.
    #--------------------------------------------------------------------------#

    def main(self, args=None):

        """
        """

        if(args.operations):
            print '\nSupported operations:\n\n' + \
                '   clone - create a clone with the --mirror option.\n' + \
                '      parameters:\n' + \
                '         src - specify the source url.\n' + \
                '\n' + \
                '   push - push a mirrored clone.\n' + \
                '      parameters:\n' + \
                '         dest - specify the destination url.\n' + \
                '\n' + \
                '   mirror - clone and then push a repository.\n' + \
                '      parameters:\n' + \
                '         src - specify the source url.\n' + \
                '         dest - specify the destination url.\n' + \
                '\n' + \
                '   archive - create a clone and archive it.\n' + \
                '      parameters:\n' + \
                '         src - specify the source url.\n' + \
                '         filename - specify the archive name to create.\n' + \
                '\n' + \
                '   expand - expand an archive.' + \
                '      parameters:\n' + \
                '         dest - specify the destination url.\n' + \
                '         filename - specify the archive name to expand.\n' + \
                '\n' + \
                '   transfer - transfer a file using xf.' + \
                '\n'
        else:
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
