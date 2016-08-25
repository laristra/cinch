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

#------------------------------------------------------------------------------#
# Check for C++11 compiler.
#------------------------------------------------------------------------------#

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

#------------------------------------------------------------------------------#
# Configure header with version information
#------------------------------------------------------------------------------#

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/doc/header.tex.in
	${CMAKE_BINARY_DIR}/doc/header.tex)

#------------------------------------------------------------------------------#
# Pandoc options for user guide
#------------------------------------------------------------------------------#

set(pandoc_options
    "--toc"
    "--include-in-header=${CMAKE_SOURCE_DIR}/cinch/tex/addtolength.tex"
    "--include-in-header=${CMAKE_BINARY_DIR}/doc/header.tex"
)

#------------------------------------------------------------------------------#
# Add user guide target
#------------------------------------------------------------------------------#

cinch_add_doc(user-guide ugconfig.py src
    user-guide-${${PROJECT_NAME}_VERSION}.pdf
    PANDOC_OPTIONS ${pandoc_options} IMAGE_GLOB "*.pdf")

#------------------------------------------------------------------------------#
# Add developer guide target
#------------------------------------------------------------------------------#

cinch_add_doc(developer-guide dgconfig.py src
    developer-guide-${${PROJECT_NAME}_VERSION}.pdf
    PANDOC_OPTIONS ${pandoc_options} IMAGE_GLOB "*.pdf")

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

///
// \\file utils.h
// \\authors ${AUTHOR}
// \date Initial file creation: ${DATE}
///

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

///
// \\file utils.cc
// \\authors ${AUTHOR}
// \date Initial file creation: ${DATE}
///

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
 * vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
 *~------------------------------------------------------------------------~--*/
""")

cinch_example_md = Template(
"""
<!-- CINCHDOC DOCUMENT(User Guide) SECTION(Conclusion) -->

# Conclusion

This is the conclusion

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

<!-- CINCHDOC DOCUMENT(User Guide) SECTION(Introduction) -->

# Introduction

This is the introduction

<!-- CINCHDOC DOCUMENT(Developer Guide) SECTION(Test) -->

# Developer Guide Utils

This is some documentation that should only be in the developer guide.
""")

cinch_app_cmake = Template(
"""
#-----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#-----------------------------------------------------------------------------~#

#------------------------------------------------------------------------------#
# Add a rule to build the executable
#------------------------------------------------------------------------------#

add_executable(app app.cc)

#------------------------------------------------------------------------------#
# Add link dependencies
#------------------------------------------------------------------------------#

target_link_libraries(app example)

#~---------------------------------------------------------------------------~-#
# Formatting options for vim.
# vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
#~---------------------------------------------------------------------------~-#
""")

cinch_app_source = Template(
"""
/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

/*!
 * \\file app.cc
 * \\authors ${AUTHOR}
 * \date Initial file creation: ${DATE}
 */

#include "example/example/utils.h"

int main(int argc, char ** argv) {
  example::myfunc();
  return 0;
} // main

/*~------------------------------------------------------------------------~--*
 * Formatting options for vim.
 * vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
 *~------------------------------------------------------------------------~--*/
""")

cinch_doc_ug = Template(
"""
#------------------------------------------------------------------------------#
# Configuration file for user guide.
#------------------------------------------------------------------------------#

opts = {

   #---------------------------------------------------------------------------#
   # Document
   #
   # The ngc document service supports multiple document targets
   # from within the distributed documentation tree, potentially within
   # a single file.  This option specifies which document should be used
   # to produce the output target of this configuration file.
   #---------------------------------------------------------------------------#

   'document' : 'User Guide',

   #---------------------------------------------------------------------------#
   # Sections Prepend List
   #
   # This options allows you to specify an order for the first N sections
   # of the document, potentially leaving the overall ordering arbitrary.
   #---------------------------------------------------------------------------#

   'sections-prepend' : [
      'Introduction'
   ],

   #---------------------------------------------------------------------------#
   # Sections List
   #
   # This option allows you to specify an order for some or all of the
   # sections in the the document.
   #---------------------------------------------------------------------------#

   'sections' : [
      'Test'
   ],

   #---------------------------------------------------------------------------#
   # Sections Append List
   #
   # This options allows you to specify an order for the last N sections
   # of the document, potentially leaving the overall ordering arbitrary.
   #---------------------------------------------------------------------------#

   'sections-append' : [
      'Conclusion'
   ]
}
""")

cinch_doc_dg = Template(
"""
#------------------------------------------------------------------------------#
# Configuration file for developer guide.
#------------------------------------------------------------------------------#

opts = {

   #---------------------------------------------------------------------------#
   # Document
   #
   # The ngc document service supports multiple document targets
   # from within the distributed documentation tree, potentially within
   # a single file.  This option specifies which document should be used
   # to produce the output target of this configuration file.
   #---------------------------------------------------------------------------#

   'document' : 'Developer Guide',

   #---------------------------------------------------------------------------#
   # Sections Prepend List
   #
   # This options allows you to specify an order for the first N sections
   # of the document, potentially leaving the overall ordering arbitrary.
   #---------------------------------------------------------------------------#

   #'sections-prepend' : [
   #   'Introduction'
   #],

   #---------------------------------------------------------------------------#
   # Sections List
   #
   # This option allows you to specify an order for some or all of the
   # sections in the the document.
   #---------------------------------------------------------------------------#

   #'sections' : [
   #   'Test'
   #],

   #---------------------------------------------------------------------------#
   # Sections Append List
   #
   # This options allows you to specify an order for the last N sections
   # of the document, potentially leaving the overall ordering arbitrary.
   #---------------------------------------------------------------------------#

   #'sections-append' : [
   #   'Conclusion'
   #]
}
""")

cinch_doc_header = Template(
"""
%~----------------------------------------------------------------------------~%
% Copyright (c) 2014 Los Alamos National Security, LLC
% All rights reserved.
%~----------------------------------------------------------------------------~%

\usepackage{fancyhdr}
\pagestyle{fancy}

\lhead{${${PROJECT_NAME}_VERSION}}
\chead{Guide}
\\rhead{\\today}

%~----------------------------------------------------------------------------~%
% Formatting for vim.
% vim: set tabstop=${TABSTOP} shiftwidth=${TABSTOP} expandtab :
%~----------------------------------------------------------------------------~%
""")

cinch_readme = Template(
"""
# Cinch Example Project

Congratulations! If you are reading this file, you have successfully created
a cinch skeleton project.  From here, you should try to configure and build
the example project:

    % mkdir build
    % cd build
    % cmake -DENABLE\_DOCUMENTATION=ON -DENABLE\_DOXYGEN=ON -DENABLE\_JENKINS\_OUTPUT -DENABLE\_UNIT\_TESTS
    % make

After you have built the project, you should have several executable and
documentation files in your build tree:

    bin/app
    lib/libexample.a
    test/example/sanity
    doc/user-guide-0.0.pdf
    doc/developer-guide-0.0.pdf
    doc/doxygen

To run the application example:

    % bin/app

This should produce, "Hello World".

To run the unit tests:

    % make test

Or optionally:

    % ctest -N (list the available unit tests)
    % ctest -V -R sanity (run tests verbose that match 'sanity')

# Push your new project to a remote git repository

To push to a remote, you will first need to create the repository on
whichever git server you plan to use.  Generally, this requires
logging-in to the server and creating an empty project.  The server
will usually tell you the path to the new project, which might look
something like:

    git@github.com:organization/project.git

Using this url as an example, to push your cinch project to the remote:

    % cd /path/to/project
    % git remote add origin git@github.com:organization/project.git
    % git push -u origin master
""")
