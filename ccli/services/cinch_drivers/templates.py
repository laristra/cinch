#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from string import Template

cinch_config_project = Template(
"""
#~----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#~----------------------------------------------------------------------------~#

project(${PROJECT})

#------------------------------------------------------------------------------#
# Set application directory
#------------------------------------------------------------------------------#

cinch_add_application_directory(app)

#------------------------------------------------------------------------------#
# Add library targets
#------------------------------------------------------------------------------#

cinch_add_library_target(example src)

#------------------------------------------------------------------------------#
# Set header suffix regular expression
#------------------------------------------------------------------------------#

set(CINCH_HEADER_SUFFIXES "\\\\.h")

#----------------------------------------------------------------------------~-#
# Formatting options for vim.
# vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
#----------------------------------------------------------------------------~-#
""")

cinch_config_packages = Template(
"""
#~----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#~----------------------------------------------------------------------------~#

include(cxx11)

check_for_cxx11_compiler(CXX11_COMPILER)

if(CXX11_COMPILER)
	enable_cxx11()
else()
	message(FATAL_ERROR "C++11 compatible compiler not found")
endif()

#----------------------------------------------------------------------------~-#
# Formatting options for vim.
# vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
#----------------------------------------------------------------------------~-#
""")

cinch_config_documentation = Template(
"""
#~----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#~----------------------------------------------------------------------------~#

#----------------------------------------------------------------------------~-#
# Formatting options for vim.
# vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
#----------------------------------------------------------------------------~-#
""")

cinch_example_cmake = Template(
"""
#~----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#~----------------------------------------------------------------------------~#

set(example_HEADERS
  utils.h
  PARENT_SCOPE
)

set(example_SOURCES
  utils.cc
  PARENT_SCOPE
)

cinch_add_unit(sanity
  SOURCES test/unit.cc
)

#----------------------------------------------------------------------------~-#
# Formatting options for vim.
# vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
#----------------------------------------------------------------------------~-#
""")

cinch_example_header = Template(
"""
/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2015 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#ifndef example_utils_h
#define example_utils_h

/*!
 * \\file utils.h
 * \\authors ${AUTHOR}
 * \date Initial file creation: ${DATE}
 */

namespace example {

void myfunc();

} // namespace example

#endif // example_utils_h

/*~-------------------------------------------------------------------------~-*
 * Formatting options for vim.
 * vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
 *~-------------------------------------------------------------------------~-*/
""")

cinch_example_source = Template(
"""
/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

/*!
 * \\file utils.cc
 * \\authors ${AUTHOR}
 * \date Initial file creation: ${DATE}
 */

#include <iostream>

#include "utils.h"

namespace example {

void myfunc() {
  std::cout << "Hello World" << std::endl;
} // myfunc

} // namespace example

/*~------------------------------------------------------------------------~--*
 * Formatting options for vim.
 * vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
 *~------------------------------------------------------------------------~--*/
""")

cinch_example_unit = Template(
"""
/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

#include <cinchtest.h>

#include "example/example/utils.h"

TEST(unit, testname) {

  CINCH_ASSERT(TRUE, 1 == 1);

} // TEST

/*~------------------------------------------------------------------------~--*
 * Formatting options for vim.
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~------------------------------------------------------------------------~--*/
""")

cinch_example_md = Template(
"""
<!-- CINCHDOC DOCUMENT(User Guide) SECTION(Test) -->

# Utils Test

This is some markdown documentation...

**This is Bold!!!**

* Bullet 1
* Bullet 2
* Bullet 3

This was generated from raw latex:
\\begin{equation}
   \\frac{\partial q}{\partial t} + \\nabla \cdot f(q) = 0
\end{equation}

<!-- CINCHDOC DOCUMENT(Developer Guide) SECTION(Test) -->

# Developer Guide Utils

This is some documentation that should only be in the developer guide.
""")
