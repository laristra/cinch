#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from string import Template

cxx_header_template = Template(
"""
/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#ifndef ${NAMESPACE_GUARD}${CLASSNAME}_h
#define ${NAMESPACE_GUARD}${CLASSNAME}_h

${NAMESPACE_START}
/*!
    \class $CLASSNAME ${FILENAME}
    \\brief $CLASSNAME provides...
 */
${TEMPLATE}class ${CLASSNAME}
{
public:

    //! Default constructor
    ${CLASSNAME}() {}

    //! Copy constructor (disabled)
    ${CLASSNAME}(const ${CLASSNAME} &) = delete;

    //! Assignment operator (disabled)
    ${CLASSNAME} & operator = (const ${CLASSNAME} &) = delete;

    //! Destructor
    ${VIRTUAL} ~${CLASSNAME}() {}

    /*!
        \\brief This method does...

        \param arg0 a value that I pass in...
        \param arg1 a value that I pass in...

        \\return an integer with...

        This method does something useful...
     */
    int methodA(double arg0, double arg1) {
        return 0;
    } // methodA

${PROTECTED}private:

    // Aggregate data members
    double val_;

}; // class ${CLASSNAME}

${NAMESPACE_END}
#endif // ${NAMESPACE_GUARD}${CLASSNAME}_h

/*~-------------------------------------------------------------------------~-*
 * Formatting options for Emacs and vim.
 *
 * mode:c++
 * indent-tabs-mode:t
 * c-basic-offset:4
 * tab-width:4
 * vim: set tabstop=4 shiftwidth=4 expandtab :
 *~-------------------------------------------------------------------------~-*/
""")
