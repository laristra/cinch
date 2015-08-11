#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import os
import re
import fnmatch
from glob import glob
from templates import *
from ccli.services.service_utils import *

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def recursive_glob(treeroot, pattern):
    results = []
    for base, dirs, files in os.walk(treeroot):
        goodfiles = fnmatch.filter(files, pattern)
        relpath = os.path.relpath(base, treeroot)
        if relpath.startswith('.'):
            relpath = ''
        results.extend(os.path.join(relpath, f) for f in goodfiles)
    return results

def create_cmakelists(args):

    """
    """

    # Setup output file name
    filename = 'CMakeLists.txt'

    spaces = ''.zfill(int(args.tabstop)).replace('0', ' ')

    if overwrite_existing(filename):
        if args.source:
            cwd = os.getcwd()
            src_glob = recursive_glob(cwd, '*.cc')
            src_glob.extend(recursive_glob(cwd, '*.c'))
            hdr_glob = recursive_glob(cwd, '*.h')

            sources = ''
            for src in src_glob:
                sources += spaces + src + '\n'

            headers = ''
            for hdr in hdr_glob:
                headers += spaces + hdr + '\n'

            cmake_output = cmake_source_template.substitute(
                PARENT=os.path.basename(os.path.abspath('.')),
                TABSTOP=args.tabstop,
                SPACES=spaces,
                SOURCES=sources,
                HEADERS=headers
            )
        elif args.app:
            cmake_output = cmake_app_template.substitute(
                PARENT=os.path.basename(os.path.abspath('.')),
                TABSTOP=args.tabstop,
                SPACES=spaces
            )
        
        # Output to file
        fd = open(filename, 'w')
        fd.write(cmake_output[1:-1])
        fd.close()

# create_cmakelists

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
