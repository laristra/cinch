#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from string import Template

cc_header_template = Template(
"""
/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2015 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#ifndef ${NAMESPACE_GUARD}${BASENAME}_h
#define ${NAMESPACE_GUARD}${BASENAME}_h

///
/// \\file ${FILENAME}
/// \\authors ${AUTHOR}
/// \date Initial file creation: ${DATE}
///

${NAMESPACE_START}///
/// \class ${CLASSNAME} ${FILENAME}
/// \\brief ${CLASSNAME} provides...
///
${TEMPLATE}class ${CLASSNAME}
{
public:

${SPACES}/// Default constructor
${SPACES}${CLASSNAME}() {}

${SPACES}/// Copy constructor (disabled)
${SPACES}${CLASSNAME}(const ${CLASSNAME} &) = delete;

${SPACES}/// Assignment operator (disabled)
${SPACES}${CLASSNAME} & operator = (const ${CLASSNAME} &) = delete;

${SPACES}/// Destructor
${SPACES}${VIRTUAL}~${CLASSNAME}() {}

${PROTECTED}private:

}; // class ${CLASSNAME}

${NAMESPACE_END}#endif // ${NAMESPACE_GUARD}${BASENAME}_h

/*~-------------------------------------------------------------------------~-*
 * Formatting options for vim.
 * vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
 *~-------------------------------------------------------------------------~-*/
""")

#------------------------------------------------------------------------------#
# vim: set tabstop=2 shiftwidth=2 expandtab :
#------------------------------------------------------------------------------#
