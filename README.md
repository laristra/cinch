<!-- CINCHDOC DOCUMENT(User Guide) SECTION(Overview) -->

# Cinch CMake Build Utilities

Cinch is a set of utilities and configuration options designed to make
cmake builds easy to use and manage.

# Installation

Cinch uses standard CMake install features. However, because Cinch depends
on its own command-line tool (Cinch-Utils) to build its documentation,
it must be installed in the stages documented in this section.

## Install the Cinch-Utils Command-Line Tool

Directions for installing cinch-utils are [here](https://github.com/losalamos/cinch-utils).

## Install Documentation

To install the Cinch documentation, you should run cmake in the Cinch
build directory with documentation enabled:

    % cmake -DCMAKE_INSTALL_PREFIX=/path/to/install -DENABLE_DOCUMENTATION=ON ..
    % make install

# General Features

## Recursive Sub-Project Structure

The Cinch build system is designed to make modular code development easy.
By modular, we mean that subprojects can be incorporated into a Cinch-based
top-level project, and they will be automatically added to the top-level
project's build targets.  This makes it easy to create new projects that
combine the capabilities of a set of subprojects.  This allows users to
build up functionality and control the functionality of the top-level
project.

## Prevent In-Place Builds

Cinch prohibits users from creating in-place builds, i.e., builds that are
rooted in the top-level project directory of a Cinch project.  If the user
attempts to configure such a build, cmake will exit with an error and
instructions for how to clean up and create an out-of-source build.

<!-- CINCHDOC DOCUMENT(User Guide) SECTION(Structure) -->

# Basic Structure

Cinch eases build system maintainence by imposing a specific structure on
the project source layout.

    project/
            app/ (optional application subdirectory)
            cinch/
            CMakeLists.txt -> cinch/cmake/ProjectLists.txt
            config/
                   documentation.cmake
                   packages.cmake
                   project.cmake
            doc/
            src/ (optional library source subdirectory)
                CMakeLists.txt -> cinch/cmake/SourceLists.txt

*You may also have any number of submodules under the project directory.*

## Description of Basic Structure

### project

The project top-level directory.

### app

An application target subdirectory.  Application targets can be added
using the *cinch\_add\_application\_directory* documented
[below](#cinch-add-application-directory).  This subdirectory
should contain a CMakeLists.txt file that adds whatever cmake targets are
needed for the specific application.

### cinch

The Cinch subdirectory.  This should be checked-out from the Cinch
git server: 'git clone --recursive git@github.com:losalamos/cinch.git'.

### CMakeLists.txt

Create a file, whichs sets *cmake_minimum_required()* and includes the Cinch ProjectLists.txt file.

### config

The project configuration directory.  This directory is covered in
detail [below](#config-subdirectory).

### doc

The documentation subdirectory.  This subdirectory should contain configuration
files for Cinch-generated [guide documentation](#guide-documentation), and
for [doxygen interface documentation](#doxygen-documentation).

### src

A library target source subdirectory.  Library targets can be added
using the *cinch\_add\_library\_target* documented
[below](#cinch-add-library-target).

## Config Subdirectory

<a name="config-subdirectory"></a>

The config subdirectory must contain the following files
that provide specialization of the project.  Although all of
the files must exist, the only file that is required to have content
is the *project.cmake* file.

### project.cmake

This file cannot be empty.  At a minimum, it must specify the name
of the top-level project by calling the CMake *project* function to
set the name, version and enabled languages for the entire project.
For more documentation, at a prompt on a machine with a valid CMake
installation, type:

% cmake --help project

Additionally, this file may call the following Cinch
function (They may also be left Null):

* cinch\_add\_application\_directory (documented [here](#cinch-add-application-directory))

    Add a project-specific build directory that should be included
    by CMake when searching for list files.  This directory should contain
    a valid CMakeLists.txt file that configures additional build targets.

* cinch\_add\_library\_target (documented [here](#cinch-add-library-target))

    Add a library target to build for this project.

* cinch\_add\_subproject (documented [here](#cinch-add-subproject))

    Add a subproject to this project.

### packages.cmake

This file is used to specify CMake find\_package requirements for
locating installed third-party packages.  The content of this file
can be any set of valid CMake commands.  Values that are set in this
file will be available to low-level CMakeLists.txt files for configuring
source-level build options.

### documentation.cmake

This file is used to add documentation targets with the
[cinch\_add\_doc](#cinch-add-doc)
interface (Doxygen documentation is handled separately).  

# Command-Line Options

Cinch provides various command-line options that may be passed on the cmake
configuration line to affect its behavior.

## Development Mode

<a name="development-mode"></a>

***CMake Option:*** **ENABLE\_CINCH\_DEVELOPMENT (default OFF)**

Put Cinch into development mode.  This option effects some of the information
that is generated by Cinch which is helpful for non-release candidates.
If this option is enabled, it will turn on the following features:

* Documentation Target Annotation  
    Documentation targets will have colorized output indicating the source
    inputs for each section of the documentation.

## Verbose Mode

<a name="verbose-mode"></a>

***CMake Option:*** **ENABLE\_CINCH\_VERBOSE (default OFF)**

Enable more detailed build output.

## Guide Documentation

<a name="guide-documentation"></a>

***CMake Option:*** **ENABLE\_DOCUMENTATION (default OFF)**

Cinch has a powerful documentation facility implemented using the Cinch
command-line utility and [Pandoc](http://johnmacfarlane.net/pandoc).
To create documentation, define a
configuration file for each document that should be created in the 'doc'
subdirectory.  Then, add markdown (.md) or latex (.tex) files to the source
tree that document whichever aspects of the project should be included.  The
caveat is that these documentation fragments should have a special comment
header at the beginning of each, of the form:

`<!-- CINCHDOC DOCUMENT(Name of Document) SECTION(Name of Section) -->`

This special header indicates for which document the fragment is intended
and the section within which it should appear.  Headers may span
multiple lines provided that `<!-- CINCHDOC` begins the comment.
If no attributes
(DOCUMENT, SECTION, etc.) are specified, the utility will use a
default document and section ('Default' and 'Default').  Multiple
fragments intended for different documents and sections may be included
within a single input file.  For latex fragments, use a header of the form:

`% CINCHDOC DOCUMENT(Name of Document) SECTION(Name of Section)`

Latex-style CINCHDOC headers must be on a single line.

Build targets can be added to the documentation.cmake file in the config
directory.  Each target should be created by calling:

*cinch\_add\_doc*(target-name config.py top-level-search-directory output)

**target-name** The build target label, i.e., a make target will be created
such that 'make target-name' can be called to generate the documentation
target.

**config.py** A configuration file that must live in the 'doc' subdirectory
of the top-level directory of your project.  This file should contain a
single python dictionary *opts* that sets the Cinch command-line
interface options for your docuement.

**top-level-search-directory** The *relative* path to the head of the
directory tree within which to search for markdown documentation files.

**output** The name of the output file that should be produced by pandoc.

## Doxygen Documentation

<a name="doxygen-documentation"></a>

***CMake Option:*** **ENABLE\_DOXYGEN (default OFF)**
***CMake Option:*** **ENABLE\_DOXYGEN\_WARN (default OFF)**

Cinch supports interface documentation using Doxygen.  The doxygen
configuration file should be called 'doxygen.conf.in' and should reside
in the 'doc' subdirectory.  For documentation on using Doxygen, please
take a look at the [Doxygen Homepage](http://www.doxygen.org).

If ENABLE\_DOXYGEN\_WARN is set to ON, normal Doxygen diagnostics and
warnings will not be suppressed.

## Unit Tests

<a name="unit-tests"></a>

***CMake Option:*** **ENABLE\_UNIT\_TESTS (default OFF)**

Cinch has support for unit testing using a combination of CTest
(the native CMake testing facility) and GoogleTest (for C++ support).
If unit tests are enabled, Cinch will create a 'test' target.  Unit tests
may be added in any subdirectory of the project simply be creating the
test source code and adding a target using the
'cinch\_add\_unit(target [source list])' function.

Cinch will check for a local GoogleTest installation on the system during
the Cmake configuration step.  If GoogleTest is not found, it will be
built by Cinch (GoogleTest source code is included with Cinch).

## Reporting

***CMake Option:*** **ENABLE\_COLOR\_OUTPUT (default ON)**

Cinch has support for information, warning, and error reporting. If
ENABLE\_COLOR\_OUTPUT is set to ON, the output will be colorized.

* **cinch\_info** Information reporting. This macro is useful for
  outputting information to standard out. It is disabled if NDEGBUG is
  not defined.

* **cinch\_warn** Warning output. This macro is useful for
  outputting non-fatal runtime warnings to standard out. It is disabled
  if NDEGBUG is not defined.

* **cinch\_error** Error output and abort. This macro is useful for
  outputting fatal runtime messages to standard error. After writing the
  message, this macro will call std::abort.

* **cinch\_assert** Execute a runtime assertion and call *cinch\_error*
  if the assertion fails, thus printing an error message and exiting
  with abort.

Here is an example of each of these macros:

```cpp
#include <cinchreporting.h>

int main(int argc, char ** argv) {

  // Print information to standard out
  cinch_info("Hello World! We got " << argc-1 << " arguments");

  // Print a warning to standard out
  if(argc < 3) {
    cinch_warn("Only got " << argc-1 << " arguments");
  } // if

  // Print an error message to standard error and exit with abort
  if(argc < 2) {
    cinch_error("This program requires at least 1 argument");
  } // if

  // Use an assertion for the above error case
  cinch_assert(argc >= 1, "This program requires at least 1 argument")

  return 0;
} // main
```

Running this code with no arguments will produce the following output
(markdown is unable to show the colorization):

    % ./example
    % Info Hello World! We got 0 arguments
    % !Warning!
    %      Message: Only got 0 arguments
    %      [line 10 example.cc]
    % !!!RUNTIME ERROR: executing std::abort!!!
    %      Message: This program requires at least 1 argument
    %      [line 15 example.cc]
    % Aborted (core dumped)

In addition to this simple macro interface, cinch also provides function
calls that can be customized to control output, e.g., to a single rank
or task id. For example, to print output only on rank 0 of an MPI
program, one could write something like this:

```cpp
// Define a simple predicate function to select a particular rank
template<size_t R>
bool is_part() {
  int part;
  MPI_Comm_rank(MPI_COMM_WORLD, &part);
  return part == R;
} // is_part

// Define a macro using the predicate to control output
#define info_one(message, part)             \
  std::stringstream ss;                     \
  ss << message;                            \
  cinch::info_impl(ss.str(), is_part<part>)

int main(int argc, char ** argv) {

  // Initialize the MPI runtime
  MPI_Init(&argc, &argv);

  // Call the custom macro with a message and rank
  info_one("This message will only be printed by rank 0", 0);

  // Finalize the MPI runtime
  MPI_Finalize();

  return 0;
} // main
```

It is left to the user to define suitable predicate functions, as it is
beyond the scope of cinch to handle every possible runtime requirement.

## Versioning

<a name="versioning"></a>

***CMake Option:*** **VERSION\_CREATION (default 'git describe')**

Cinch can automatically create version information for projects that use git.
This feature uses the 'git describe' function, which creates a version from
the most recent annotated tag with a patch level based on the number of
commits since that tag and a partial hash key.  For example, if the most
recent annotated tag is "1.0" and there have been 35 commits since, the
Cinch-created version would be similar to: 1.0-35-g2f657a

For actual releases, this approach may not be optimal.  In this case, Cinch
allows you to override the automatic versioning by specifying a static version
to cmake via the VERSION\_CREATION option.  Simply set this to the
desired version and it will be used.

# Release

This software has been approved for open source release and has been assigned **LA-CC-15-070**.

# Copyright

Copyright (c) 2016, Los Alamos National Security, LLC
All rights reserved.

Copyright 2016. Los Alamos National Security, LLC. This software was produced under U.S. Government contract DE-AC52-06NA25396 for Los Alamos National Laboratory (LANL), which is operated by Los Alamos National Security, LLC for the U.S. Department of Energy. The U.S. Government has rights to use, reproduce, and distribute this software.  NEITHER THE GOVERNMENT NOR LOS ALAMOS NATIONAL SECURITY, LLC MAKES ANY WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY LIABILITY FOR THE USE OF THIS SOFTWARE.  If software is modified to produce derivative works, such modified software should be clearly marked, so as not to confuse it with the version available from LANL.
 
Additionally, redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of Los Alamos National Security, LLC, Los Alamos National Laboratory, LANL, the U.S. Government, nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY LOS ALAMOS NATIONAL SECURITY, LLC AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LOS ALAMOS NATIONAL SECURITY, LLC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

<!-- vim: set tabstop=2 shiftwidth=2 expandtab fo=cqt tw=72 : -->
