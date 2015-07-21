<!-- CINCHDOC DOCUMENT(User Guide) CHAPTER(Overview) -->

# Cinch CMake Build Utilities

Cinch is a set of utilities and configuration options designed to make
cmake builds easy to use and manage.

[Installation](INSTALL.md)

# General Features

## Recursive Sub-Project Structure

The cinch build system is designed to make modular code development easy.
By modular, we mean that subprojects can be incorporated into a cinch-based
top-level project, and they will be automatically added to the top-level
project's build targets.  This makes it easy to create new projects that
combine the capabilities of a set of subprojects.  This allows users to
build up functionality and control the functionality of the top-level
project.

## Prevent In-Place Builds

Cinch prohibits users from creating in-place builds, i.e., builds that are
rooted in the top-level project directory of a cinch project.  If the user
attempts to configure such a build, cmake will exit with an error and
instructions for how to clean up and create an out-of-source build.

<!-- CINCHDOC DOCUMENT(User Guide) CHAPTER(Structure) -->

# Basic Structure

Cinch eases build system maintainence by imposing a specific structure on
the project source layout.

    project/
            app/
            cinch/
            CMakeLists.txt -> cinch/cmake/ProjectLists.txt
            config/
                   documentation.cmake
                   packages.cmake
                   project.cmake
            doc/
            src/
                CMakeLists.txt -> cinch/cmake/SourceLists.txt

*You may also have any number of submodules under the project directory.*

## Description of Basic Structure

### project

The project top-level directory.

### app

The application target subdirectory.  The actual name of this directory
is configurable in the *project.cmake* configuration file detailed
[below](#config-subdirectory).  This subdirectory
should contain a CMakeLists.txt file that adds whatever cmake targets are
needed for the specific application.

### cinch

The cinch subdirectory.  This should be checked-out from the cinch
git server: 'git clone git@darwin.lanl.gov:cinch.git'.

### CMakeLists.txt

A link to the cinch ProjectLists.txt file.

### config

The project configuration directory.  This directory is covered in
detail [below](#config-subdirectory).

### doc

The documentation subdirectory.  This subdirectory should contain configuration
files for cinch-generated [guide documentation](#guide-documentation), and
for [doxygen interface documentation](#doxygen-documentation).

### src

The library source subdirectory.  The structure for this subdirectory
is covered in detail [below](#library-source).

## Config Subdirectory{#config-subdirectory}

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

Additionally, this file may set the following Cinch
variables(They may also be left Null):

* CINCH\_APPLICATION\_DIRECTORY

    The name of a project-specific build directory that should be included
    by CMake when searching for list files.  This directory should contain
    a valid CMakeLists.txt file that configures additional build targets.

* CINCH\_LIBRARY\_TARGET

    The name of the library target to build for this project,
    e.g., setting this variable with
    'set(CINCH\_LIBRARY\_TARGET test)' will create a library
    target libtest.libext.

* CINCH\_CONFIG\_SUBPROJECTS

    A semicolon-delimited list of subprojects that should be included
    in the build.

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

## Library Source Subdirectory{#library-source}

The library source subdirectory for a cinch project... FIXME

# Command-Line Options

Cinch provides various command-line options that may be passed on the cmake
configuration line to affect its behavior.

## Project Version{#project-version}

***CMake Option:*** **STATIC\_VERSION (default OFF)**

Cinch can automatically create version information for projects that use git.
This feature uses the 'git describe' function, which creates a version from
the most recent annotated tag with a patch level based on the number of
commits since that tag and a partial hash key.  For example, if the most
recent annotated tag is "1.0" and there have been 35 commits since, the
cinch-created version would be similar to: 1.0-35-g2f657a

For new releases, this approach may not be optimal.  In this case, cinch
allows you to override the automatic versioning by specifying a static version
to cmake via the STATIC\_VERSION option.  Simply set this to the
desired version and it will be used.

## Unit Tests with GoogleTest{#unit-tests}

***CMake Option:*** **ENABLE\_UNIT\_TESTS (default OFF)**

Cinch has support for unit testing using a combination of CTest
(the native CMake testing facility) and GoogleTest (for C++ support).
If unit tests are enabled, cinch will create a 'test' target.  Unit tests
may be added in any subdirectory of the project simply be creating the
test source code and adding a target using the
'cinch\_add\_unit(target [source list])' function.

Cinch will check for a local GoogleTest installation on the system during
the Cmake configuration step.  If GoogleTest is not found, it will be
built by cinch (GoogleTest source code is included with cinch).

## Guide Documentation{#guide-documentation}

***CMake Option:*** **ENABLE\_DOCUMENTATION (default OFF)**

Cinch has a powerful documentation facility implemented using the cinch
command-line utility and [Pandoc](http://johnmacfarlane.net/pandoc).
To create documentation, define a
configuration file for each document that should be created in the 'doc'
subdirectory.  Then, add markdown (.md) or latex (.tex) files to the source
tree that document whichever aspects of the project should be included.  The
caveat is that these documentation fragments should have a special comment
header at the beginning of each, of the form:

`<!-- CINCHDOC DOCUMENT(Name of Document) CHAPTER(Name of Chapter) -->`

This special header indicates for which document the fragment is intended
and the chapter within which it should appear.  Headers may span
multiple lines provided that `<!-- CINCHDOC` begins the comment.
If no attributes
(DOCUMENT, CHAPTER, etc.) are specified, the utility will use a
default document and chapter ('Default' and 'Default').  Multiple
fragments intended for different documents and chapter may be included
within a single input file.  For latex fragments, use a header of the form:

`% CINCHDOC DOCUMENT(Name of Document) CHAPTER(Name of Chapter)`

Latex-style CINCHDOC headers must be on a single line.

Build targets can be added to the documentation.cmake file in the config
directory.  Each target should be created by calling:

*cinch\_add\_doc*(target-name config.py top-level-search-directory output)

**target-name** The build target label, i.e., a make target will be created
such that 'make target-name' can be called to generate the documentation
target.

**config.py** A configuration file that must live in the 'doc' subdirectory
of the top-level directory of your project.  This file should contain a
single python dictionary *opts* that sets the cinch command-line
interface options for your docuement.

**top-level-search-directory** The *relative* path to the head of the
directory tree within which to search for markdown documentation files.

**output** The name of the output file that should be produced by pandoc.

## Doxygen Documentation{#doxygen-documentation}

***CMake Option:*** **ENABLE\_DOXYGEN (default OFF)**

Cinch supports interface documentation using Doxygen.  The doxygen
configuration file should be called 'doxygen.conf.in' and should reside
in the 'doc' subdirectory.  For documentation on using Doxygen, please
take a look at the [Doxygen Homepage](http://www.doxygen.org).

