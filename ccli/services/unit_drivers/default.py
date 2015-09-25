#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from unit import unit_template
from ccli.services.service_utils import *

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def create_unit_test(args):

    """
    """

    name_a = (args.name if args.name != None else 'testname')
    name_fill = 'testname'

    # Setup output file name
    filename = (args.case if args.case != None else 'unamed') + '.cc'

    # Setup spaces to use for tabs
    spaces = tab_spaces(args)

    unit_output = unit_template.substitute(
        CASE=args.case,
        NAME_A=name_a,
        NAME_B=name_fill,
        NAME_C=name_fill,
        TABSTOP=args.tabstop,
        SPACES=spaces
    )
    
    # Output to file
    fd = open(filename, 'w')
    fd.write(unit_output[1:-1])
    fd.close()

# create_unit_test

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
