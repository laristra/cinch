#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from __future__ import generators
import random
import sys
import argparse
from ccli.__init__ import __version__
from ccli.factory import *
from ccli.base import *
from ccli.utils import *
from ccli.services import *

#------------------------------------------------------------------------------#
# Internal main routine.  This is the top-level once we are inside of the
# cinch module.
#------------------------------------------------------------------------------#

def main():

    """
    """

    driver = create_driver()
    return driver.main()

# main

#------------------------------------------------------------------------------#
# Create the command-line driver.
#------------------------------------------------------------------------------#

def create_driver():

    """
    """

    driver = CLIDriver()
    return driver

# create_driver

#------------------------------------------------------------------------------#
# CLIDriver class
#------------------------------------------------------------------------------#

class CLIDriver():

    """
    """

    def __init__(self):

        """
        """

        # initialize empty services dictionary
        self.services = dict()

        # create top-level argument parser
        self.parser = argparse.ArgumentParser()

        # create subparsers object to pass into services
        self.subparsers = self.parser.add_subparsers(help='sub-command help')

        # create all available services
        create_services(self.services, self.subparsers)

        # add command-line options
        self.parser.add_argument('-v', '--version', action='version',
            version='ccli version: ' + __version__)

    # __init__

    def main(self, args=None):

        """
        """

        # parse arguments and call the appropriate function
        # as set by the Service subclass.
        args = self.parser.parse_args()
        args.func(args)

    # main

# class CLIDriver

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
