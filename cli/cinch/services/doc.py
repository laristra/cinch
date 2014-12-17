#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import ast
from pickle import Unpickler
from collections import OrderedDict

from cinch.base import Service
from cinch.services.doc_drivers.walk import *

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
        self.parser = subparsers.add_parser('doc',
            help='Service to generate documentation using Pandoc.')

        # add command-line options
        self.parser.add_argument('-c', '--config', action="store",
            help='configuration module.' +
                '  Load the configuration information' +
                ' from python module CONFIG.')

        self.parser.add_argument('-o', '--output', action="store",
            help='output target.' +
                '  Write output to file OUTPUT.')

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
        suffixes = (".md", ".markdown", ".mdown", ".mkd", ".mkdn", ".mdwn")

        # Setup default options
        opts = {
            'document' : 'Default',
            'output' : 'cinchdoc.mdwn'
        }

        #----------------------------------------------------------------------#
        # Process command-line arguments
        #----------------------------------------------------------------------#

        # Check for user-defined configuration and import as module
        # if option is set
        if args.config:
            (path, configfile) = os.path.split(args.config)

            # Add configfile path to module search path
            if not path:
                sys.path.append(os.getcwd())
            else:
                sys.path.append(path)

            # import the options from the specified module
            opts = __import__(os.path.splitext(configfile)[0]).opts
        # if

        # Check for command-line output specification
        # NOTE: this option will over-write the value specified in
        # the configuration file
        if args.output:
            opts['output'] = args.output

        #----------------------------------------------------------------------#

        # Create documents storage
        documents = dict()

        # Create default document
        documents['Default'] = Document('Default')

        # Set default document
        if not opts['document'] in documents:
            documents[opts['document']] = Document(opts['document'])
        doc = documents[opts['document']]

        # Process chapters-prepend option
        for chapter in opts['chapters-prepend']:
            doc.add_chapter(chapter)

        # Process chapters option
        for chapter in opts['chapters']:
            doc.add_chapter(chapter)

        # Search sub-directories for documentation files
        walk_tree(args.directory, suffixes, documents, opts['document'])

        # Remove the default chapter if chapters were found
        if len(doc.chapters()) and 'Default' in doc.chapters():
            doc.delete_chapter('Default')

        #----------------------------------------------------------------------#
        # Process chapters-append
        # This removes chapter-append keys and then re-adds them, this
        # effectively sorts them to the end in-order because we are using
        # an ordered dict.
        #----------------------------------------------------------------------#

        saved = dict()
        for chapter in doc.chapters():
            for key in opts['chapters-append']:
                if key == chapter:
                    saved[key] = doc.chapters()[key]

        for key in saved:
            doc.delete_chapter(key)

        for key in saved:
            doc.add_chapter(key, saved[key])

        #----------------------------------------------------------------------#
        # End Process chapters-append
        #----------------------------------------------------------------------#

        # For now, just write to the specified output
        doc.write(opts['output'])

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
