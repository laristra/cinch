#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from string import Template

cc_stand_alone_template = Template(
"""
/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

///
/// \\file
/// \date Initial file creation: ${DATE}
///
${NAMESPACE_START}
${NAMESPACE_END}
/*~------------------------------------------------------------------------~--*
 * Formatting options for vim.
 * vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
 *~------------------------------------------------------------------------~--*/
""")

#------------------------------------------------------------------------------#
# vim: set tabstop=2 shiftwidth=2 expandtab :
#------------------------------------------------------------------------------#
