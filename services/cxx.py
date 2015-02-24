#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from ccli.base import Service
from ccli.services.cxx_drivers.default import *

#------------------------------------------------------------------------------#
# Source handler.
#------------------------------------------------------------------------------#

class CINCHSource(Service):

    #--------------------------------------------------------------------------#
    # Initialization.
    #--------------------------------------------------------------------------#

    def __init__(self, subparsers):

        """
        """

        # get a command-line parser
        self.parser = subparsers.add_parser('cxx',
            help='Service to generate c++ file templates.')

        # add command-line options
        self.parser.add_argument('-t', '--template', action="store_true",
            help='create a templated class prototype')

        self.parser.add_argument('-b', '--baseclass', action="store_true",
            help='create a base class from which other classes can derive. ' +
                'In addition to adding a protected section, this flag ' +
                'causes the desctructor to be virtual.')

        self.parser.add_argument('-c', '--ccfile', action="store_true",
            help='genefate a c++ source file (in addition to the header)')

        self.parser.add_argument('-n', '--namespace', action="store",
            help='namespace name.' +
                '  If this argument is provided,' +
                ' the created class definitions will be wrapped in ' +
                ' the given namespace.')

        self.parser.add_argument('classname',
            help='the name of the class.' +
                '  This name will also be used for the output file' +
                ' unless the -f option is specified explicitly.')

        self.parser.add_argument('-f', '--filename', action="store",
            help='output file base name.' +
                '  If this argument is not provided,' +
                ' output file names will be created using the classname.')

        # set the callback for this sub-command
        self.parser.set_defaults(func=self.main)

    # __init__

    #--------------------------------------------------------------------------#
    # Main.
    #--------------------------------------------------------------------------#

    def main(self, args=None):

        """
        """

        create_cxx_files(args)

    # main

    #--------------------------------------------------------------------------#
    # Object factory for service creation.
    #--------------------------------------------------------------------------#

    class Factory:
        def create(self, subparsers): return CINCHSource(subparsers)

# class CINCHSource

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
