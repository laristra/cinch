#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import re
import os
from os.path import join
from ccli.services.doc_drivers.utils import *
from ccli.services.doc_drivers.document import *

symbols = {
    'document' : 'DOCUMENT',
    'chapter' : 'CHAPTER',
}

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def walk_tree(directory, suffixes, documents, \
    initial_document, verbose, development):

    current_document = documents[initial_document]
    current_chapter = current_document.chapter('Default')

    if(verbose):
        print 'ccli: search directory ' + directory
        print 'ccli: initial document ' + \
            current_document.title()
        print 'ccli: initial chapter ' + \
            current_chapter.title()
    # if

    # Walk directory looking for files in suffixes
    for root, dirs, files in os.walk(directory):
        for file in files:

            if file.endswith(suffixes):

                # Open file to search for symbols
                with open(join(root,file)) as fd:
                    if(verbose):
                        print 'ccli: processing ---- ' + file + ' ----'

                    # Grab all of the lines
                    lines = fd.readlines()

                    # Go through the lines
                    for index, line in enumerate(lines):

                        # If this is a doc line, parse the symbols
                        #if '<!-- CINCHDOC' in line or '% CINCHDOC' in line:
                        if begin_identifier(line):
                            parsed = {}

                            # Check to see if this is all on one line
                            # If this is a latex file, the symbols
                            # must be on a single line
                            #if '-->' in line or '% CINCHDOC' in line:
                            if single_line_identifier(line):
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
                                    
                                    #if '-->' in line:
                                    if end_identifier(line):
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
                                if not parsed['document'] in documents:
                                    documents[parsed['document']] = \
                                        Document(parsed['document'])
                                # if
            
                                current_document = \
                                    documents[parsed['document']]

                                if(verbose):
                                    print 'ccli: -> document ' + \
                                        current_document.title()
                                # if
                            # if

                            # See if the chapter needs to be created or reset
                            if 'chapter' in parsed:
                                current_chapter = \
                                    current_document.chapter(parsed['chapter'])

                                if(verbose):
                                    print 'ccli: -> chapter ' + \
                                        current_chapter.title()
                                # if
                            # if

                            # Append file information
                            current_chapter.append('<!-- cinch metadata\n')
                            current_chapter.append('FILE(' + join(root, file) +
                                ')\n')
                            current_chapter.append('-->\n')
                            
                            if(development):
                                current_chapter.append('\n\color{green}')
                                current_chapter.append('###############\n\n')
                                current_chapter.append('\color{blue}CINCH METADATA ')
                                current_chapter.append('\color{black}FILE:' +
                                    join(root, file) + '\n')
                            # if

                            # Read the actual content until the end
                            # of the file, or until another CINCHDOC block
                            # is encountered
                            while True and (index < len(lines) - 1):
                                index += 1
                                line = lines[index]

                                #if '<!-- CINCHDOC' in line or \
                                #    '% CINCHDOC' in line:
                                if begin_identifier(line):
                                    break
                                # if

                                # Strip comments (must be done after
                                # cinch annotations directly above
                                if begin_comment_identifier(line):
                                    continue
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
