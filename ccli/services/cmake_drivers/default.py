#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import os.path
from templates import *
from ccli.services.service_utils import *

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def create_cmakelists(args):

    """
    """

    # Setup output file name
    filename = 'CMakeLists.txt'

    if overwrite_existing(filename):
        if args.source:
            cmake_output = cmake_source_template.substitute(
                PARENT=os.path.basename(os.path.abspath('..')),
                CMAKE_CURRENT_SOURCE_DIR='${CMAKE_CURRENT_SOURCE_DIR}'
            )
        elif args.app:
            cmake_output = cmake_app_template.substitute(
                PARENT=os.path.basename(os.path.abspath('..')),
                CMAKE_CURRENT_SOURCE_DIR='${CMAKE_CURRENT_SOURCE_DIR}'
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
