#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import os.path

def overwrite_existing(filename):

    """
    """

    if os.path.exists(filename):
        return True if raw_input(filename +
            ' exists.  Overwrite? [y/N]: ') is 'y' else False
    else:
        return True

# overwrite_existing

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
