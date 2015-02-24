#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import sys

from ccli.base import Service
from ccli.services.brand_drivers.walk import *

#------------------------------------------------------------------------------#
# Documentation handler.
#------------------------------------------------------------------------------#

class CINCHDoc(Service):

    #--------------------------------------------------------------------------#
    # Initialization.
    #--------------------------------------------------------------------------#

    def __init__(self, subparsers):

        """
        """

        # get a command-line parser
        self.parser = subparsers.add_parser('brand',
            help='Service to generate branding information in source files.')

        # add command-line options
        self.parser.add_argument('-b', '--brand', action="store",
            help='branding information.' +
                '  Load the branding information' +
                ' from python module BRAND.')

        self.parser.add_argument('syntax',
            choices=['cxx', 'cmake', 'python'],
            help='Input syntax for search and replacement.')

        self.parser.add_argument('directory',
            help='Top-level source directory at which to begin parsing.')

        # set the callback for this sub-command
        self.parser.set_defaults(func=self.main)

    # __init__

    #--------------------------------------------------------------------------#
    # Main.
    #--------------------------------------------------------------------------#

    def main(self, args=None):

        """
        """

        #----------------------------------------------------------------------#
        # Process command-line arguments
        #----------------------------------------------------------------------#

        # Check for user-defined configuration and import as module
        # if option is set
        if args.brand:
            (path, brandfile) = os.path.split(args.brand)

            # Add brandfile path to module search path
            if not path:
                sys.path.append(os.getcwd())
            else:
                sys.path.append(path)

            # import the options from the specified module
            brand = __import__(os.path.splitext(brandfile)[0]).brand
        # if

        walk_tree(args.directory, args.syntax, brand)

    # main

    #--------------------------------------------------------------------------#
    # Object factory for service creation.
    #--------------------------------------------------------------------------#

    class Factory:
        def create(self, subparsers): return CINCHDoc(subparsers)
    # class Factory

# class CINCHDoc

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
