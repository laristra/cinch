#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from ccli.base import Service
from ccli.services.unit_drivers.default import *

#------------------------------------------------------------------------------#
# Unit test handler.
#------------------------------------------------------------------------------#

class CINCHUnitTest(Service):

    #--------------------------------------------------------------------------#
    # Initialization.
    #--------------------------------------------------------------------------#

    def __init__(self, subparsers):

        """
        """

        # get a command-line parser
        self.parser = subparsers.add_parser('unit',
            help='Service to generate unit-test templates.')

        self.parser.add_argument('case',
            help='the name of the unit test case.' +
                '   A unit case may contain several related tests.')

        self.parser.add_argument('name', nargs='?',
            help='the name of the unit test.' +
                '   A unit case may contain several related tests.')

        # set the callback for this sub-command
        self.parser.set_defaults(func=self.main)

    # __init__

    #--------------------------------------------------------------------------#
    # Main.
    #--------------------------------------------------------------------------#

    def main(self, args=None):

        """
        """

        create_unit_test(args)

    # main

    #--------------------------------------------------------------------------#
    # Object factory for service creation.
    #--------------------------------------------------------------------------#

    class Factory:
        def create(self, subparsers): return CINCHUnitTest(subparsers)

# class CINCHUnitTest

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
