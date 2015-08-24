#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from string import Template

cxx_header_template = Template(
"""
/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2015 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#ifndef ${NAMESPACE_GUARD}${CLASSNAME}_h
#define ${NAMESPACE_GUARD}${CLASSNAME}_h

/*!
 * \\file ${FILENAME}
 * \\authors ${AUTHOR}
 * \date Initial file creation: ${DATE}
 */

${NAMESPACE_START}/*!
${SPACES}\class ${CLASSNAME} ${FILENAME}
${SPACES}\\brief ${CLASSNAME} provides...
 */
${TEMPLATE}class ${CLASSNAME}
{
public:

${SPACES}//! Default constructor
${SPACES}${CLASSNAME}() {}

${SPACES}//! Copy constructor (disabled)
${SPACES}${CLASSNAME}(const ${CLASSNAME} &) = delete;

${SPACES}//! Assignment operator (disabled)
${SPACES}${CLASSNAME} & operator = (const ${CLASSNAME} &) = delete;

${SPACES}//! Destructor
${SPACES}${VIRTUAL} ~${CLASSNAME}() {}

#if 0
${SPACES}/*!
${SPACES}\\brief This method does...

${SPACES}\param arg0 a value that I pass in...
${SPACES}\param arg1 a value that I pass in...

${SPACES}\\return an integer with...

${SPACES}This method does something useful...
${SPACES}*/
${SPACES}int methodA(double arg0, double arg1) {
${SPACES}${SPACES}return 0;
${SPACES}} // methodA
#endif // if 0

${PROTECTED}private:

${SPACES}// Aggregate data members
#if 0
${SPACES}// This is an example data member.  You should delete
${SPACES}// this definition.
${SPACES}double val_;
#endif // if 0

}; // class ${CLASSNAME}

${NAMESPACE_END}#endif // ${NAMESPACE_GUARD}${CLASSNAME}_h

/*~-------------------------------------------------------------------------~-*
 * Formatting options for vim.
 * vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
 *~-------------------------------------------------------------------------~-*/
""")

#------------------------------------------------------------------------------#
# vim: set tabstop=2 shiftwidth=2 expandtab :
#------------------------------------------------------------------------------#
