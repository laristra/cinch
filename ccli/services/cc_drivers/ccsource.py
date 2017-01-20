#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from string import Template

cc_source_template = Template(
"""
/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

///
/// \\file ${FILENAME}
/// \\authors ${AUTHOR}
/// \date Initial file creation: ${DATE}
///

#include "${HEADER}"
${NAMESPACE_START}
#if 0
${TEMPLATE}void ${CLASSNAME}${TEMPLATE_TYPE}::method(argument_type & t)
{
} // ${CLASSNAME}${TEMPLATE_TYPE}::method

${TEMPLATE}void ${CLASSNAME}${TEMPLATE_TYPE}::method(argument_type & t)
{
} // ${CLASSNAME}${TEMPLATE_TYPE}::method
#endif
${NAMESPACE_END}
/*~------------------------------------------------------------------------~--*
 * Formatting options for vim.
 * vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
 *~------------------------------------------------------------------------~--*/
""")

#------------------------------------------------------------------------------#
# vim: set tabstop=2 shiftwidth=2 expandtab :
#------------------------------------------------------------------------------#
