#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import ast
from pickle import Unpickler
from ngccli.base import Service
from ngccli.services.doc_drivers.walk import *

#------------------------------------------------------------------------------#
# Documentation handler.
#------------------------------------------------------------------------------#

class NGCDoc(Service):

    #--------------------------------------------------------------------------#
    # Initialization.
    #--------------------------------------------------------------------------#

    def __init__(self, subparsers):

        """
        """

        # get a command-line parser
        self.parser = subparsers.add_parser('doc',
            help='Service to generate documentation using Pandoc.')

        # add command-line options
        self.parser.add_argument('-c', '--config', action="store",
            help='configuration module.' +
                '  Load the configuration information' +
                ' from python module CONFIG.')

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

        # Recognized file suffixes
        suffixes = (".markdown", ".mdown", ".mkd", ".mkdn", ".mdwn")

        # Setup default options
        opts = {
            'document' : 'default',
            'output' : 'ngcdoc.mdwn'
        }

        # Check for user-defined configuration and import as module
        # if option is set
        if args.config:
            opts = __import__(os.path.splitext(args.config)[0]).opts

        # Create documents storage
        documents = dict()

        # Search sub-directories for documentation files
        walk_tree(args.directory, suffixes, documents)

        # For now, just write to the specified output
        documents[opts['document']].write(opts['output'])

    # main

    #--------------------------------------------------------------------------#
    # Object factory for service creation.
    #--------------------------------------------------------------------------#

    class Factory:
        def create(self, subparsers): return NGCDoc(subparsers)
    # class Factory

# class NGCDoc

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
