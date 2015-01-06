#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from string import Template

cpp_header_template = Template(
"""
/*----------------------------------------------------------------------------*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *----------------------------------------------------------------------------*/

#ifndef ${CLASSNAME}_hh
#define ${CLASSNAME}_hh

/*!
    \class $CLASSNAME ${FILENAME}
    \\brief $CLASSNAME provides...
 */
${TEMPLATE}class ${CLASSNAME}
{
public:

    //! Default constructor
    ${CLASSNAME} {}

    //! Destructor
    ${VIRTUAL} ~${CLASSNAME}() {}

${PROTECTED}private:

    //! Copy constructor
    ${CLASSNAME}(const & ${CLASSNAME}) {} = delete;

    //! Assignment operator
    ${CLASSNAME} & operator = (const & ${CLASSNAME}) {} = delete;

}; // class ${CLASSNAME}

#endif // ${CLASSNAME}_hh

/*----------------------------------------------------------------------------*
 * Formatting options for Emacs and vim.
 *
 * mode:c++
 * indent-tabs-mode:t
 * c-basic-offset:4
 * tab-width:4
 * vim: set tabstop=4 shiftwidth=4 expandtab :
 *----------------------------------------------------------------------------*/
""")
