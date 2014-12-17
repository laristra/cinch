#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from string import Template

cpp_source_template = Template(
"""
/*----------------------------------------------------------------------------*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *----------------------------------------------------------------------------*/

#include <${FILENAME}>

${TEMPLATE}void ${CLASSNAME}${TEMPLATE_TYPE}::method(argument_type & t)
{
} // ${CLASSNAME}${TEMPLATE_TYPE}::method

${TEMPLATE}void ${CLASSNAME}${TEMPLATE_TYPE}::method(argument_type & t)
{
} // ${CLASSNAME}${TEMPLATE_TYPE}::method

/*----------------------------------------------------------------------------*
 * Formatting options for Emacs and vim.
 *
 * mode:c++
 * indent-tabs-mode:t
 * c-basic-offset:2
 * tab-width:2
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *----------------------------------------------------------------------------*/
""")
