#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from ccli.base import Service
from ccli.services.cmake_drivers.generate import *

#------------------------------------------------------------------------------#
# CMake handler.
#------------------------------------------------------------------------------#

class CINCHCMake(Service):

    #--------------------------------------------------------------------------#
    # Initialization.
    #--------------------------------------------------------------------------#

    def __init__(self, subparsers):

        """
        """

        # get a command-line parser
        self.parser = subparsers.add_parser('cmake',
            help='Service to generate cmake templates.')

        self.parser.add_argument('-s', '--source', action="store_true",
            help='create a CMake template suitable for inclusion in ' +
                'a library source sub-directory.')

        self.parser.add_argument('-a', '--app', action="store_true",
            help='create a CMake template suitable for inclusion in ' +
                'an application source directory.')

        self.parser.add_argument('-ts', '--tabstop', action="store",
            default=2, help='set the default tabstop width ')

        # set the callback for this sub-command
        self.parser.set_defaults(func=self.main)

    # __init__

    #--------------------------------------------------------------------------#
    # Main.
    #--------------------------------------------------------------------------#

    def main(self, args=None):

        """
        """

        generate(args)

    # main

    #--------------------------------------------------------------------------#
    # Object factory for service creation.
    #--------------------------------------------------------------------------#

    class Factory:
        def create(self, subparsers): return CINCHCMake(subparsers)

# class CINCHCMake

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
