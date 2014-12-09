#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import re
import os
from os.path import join
from ngccli.services.doc_drivers.utils import *
from ngccli.services.doc_drivers.document import *

symbols = {
    'document' : 'DOCUMENT',
    'chapter' : 'CHAPTER',
}

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def walk_tree(directory, suffixes, documents):

    current_document = documents['Default']
    current_chapter = current_document.chapter('Default')

    # Walk directory looking for files in suffixes
    for root, dirs, files in os.walk(directory):
        for file in files:

            if file.endswith(suffixes):

                # Open file to search for symbols
                with open(join(root,file)) as fd:

                    # Grab all of the lines
                    lines = fd.readlines()

                    # Go through the lines
                    for index, line in enumerate(lines):

                        # If this is a doc line, parse the symbols
                        if '<!-- NGCDOC' in line:
                            parsed = {}

                            # Check to see if this is all on one line
                            if '-->' in line:
                                # If it is all on one line,
                                # read all of the symbols off of the line
                                for key in symbols:
                                    if symbols[key] in line:
                                        parsed[key] = \
                                            read_token(symbols[key], line)
                            else:
                                # If not, read symbols until a close-comment
                                # is encountered
                                while True:
                                    index += 1
                                    line = lines[index]
                                    
                                    if '-->' in line:
                                        break

                                    for key in symbols:
                                        if symbols[key] in line:
                                            parsed[key] = \
                                                read_token(symbols[key], line)
                                        # if
                                    # for
                                # while
                            # if

                            # See if the document needs to be created or reset
                            if 'document' in parsed:
                                print parsed['document']
                                print documents
                                for key in documents:
                                    print "Doc Key: ", key
                                if not parsed['document'] in documents:
                                    documents[parsed['document']] = \
                                        Document(parsed['document'])
                                # if
            
                                current_document = \
                                    documents[parsed['document']]
                            # if

                            # See if the chapter needs to be created or reset
                            if 'chapter' in parsed:
                                current_chapter = \
                                    current_document.chapter(parsed['chapter'])
                            # if

                            # Read the actual content until the end
                            # of the file, or until another NGCDOC block
                            # is encountered
                            while True and (index < len(lines) - 1):
                                index += 1
                                line = lines[index]

                                if '<!-- NGCDOC' in line:
                                    break
                                # if

                                current_chapter.append(line)
                            # while
                        # if
                    # for
                # with
            # if
        # for
    # for
# walk_tree

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
