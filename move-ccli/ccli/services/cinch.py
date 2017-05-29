#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from ccli.base import Service
from ccli.services.cinch_drivers.create_project import *

#------------------------------------------------------------------------------#
# Cinch handler.
#------------------------------------------------------------------------------#

class CINCHCinch(Service):

    #--------------------------------------------------------------------------#
    # Initialization.
    #--------------------------------------------------------------------------#

    def __init__(self, subparsers):

        """
        """

        # get a command-line parser
        self.parser = subparsers.add_parser('cinch',
            help='Service to generate cinch project skeletons.')

        self.parser.add_argument('-ts', '--tabstop', action="store",
            default=2, help='set the default tabstop width ')

        self.parser.add_argument('name',
            help='the name of the project.'+
                '  This name will be used to create a new git project' +
                ' with a skeleton cinch build system.')

        # set the callback for this sub-command
        self.parser.set_defaults(func=self.main)

    # __init__

    #--------------------------------------------------------------------------#
    # Main.
    #--------------------------------------------------------------------------#

    def main(self, args=None):

        """
        """

        create_project(args)

    # main

    #--------------------------------------------------------------------------#
    # Object factory for service creation.
    #--------------------------------------------------------------------------#

    class Factory:
        def create(self, subparsers): return CINCHCinch(subparsers)

# class CINCHCinch

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
