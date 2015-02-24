#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import re
import os
from os.path import join
from ccli.services.brand_drivers.utils import *

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def walk_tree(directory, syn, brand):

    syntax = comment_syntax[syn]

    # Walk directory looking for files in suffixes
    for root, dirs, files in os.walk(directory):
        for file in files:

            infile = join(root,file)
            outfile = join(root,file) + '.tmp'

            if file.endswith(syntax['suffixes']) and \
                not os.path.islink(infile):

                # Open file to search for symbols
                with open(infile) as fd, open(outfile, 'w+') as out:

                    # Grab all of the lines
                    #lines = fd.readlines()

                    # Go through the lines
                    refs = init_refs()
                    while True:
                        line = fd.readline()

                        if not line:
                            break

                        if begin_identifier(line, syntax, refs):
                            while True:
                                line = fd.readline()

                                if end_identifier(line, syntax, refs):
                                    out.write(refs['begin'] + '\n') 
                                    for cmt in brand[str(refs['index'])]:
                                        out.write(syntax['prepend'] + \
                                            cmt + '\n')
                                    out.write(refs['end'] + '\n') 
                                    break
                            # while
                        else:
                            out.write(line) 
                        # if
                    # for
                # with

                # Replace original file
                os.rename(outfile, infile)
            # if
        # for
    # for
# walk_tree

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
