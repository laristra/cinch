# Cinch CMake Build Utilities

Cinch is a set of utilities and configuration options designed to make
cmake builds easy to use and manage.

# Basic Structure

Cinch eases build system maintainence by imposing a specific structure on
the project source layout.

    project/
	         CMakeLists.txt
            src/
            app/
            doc/
            cinch/

**project**

The project top-level directory.

**CMakeLists.txt**

The cinch CMakeLists.txt file.  The user should edit the top few lines
of this file to match the project name and targets.

**src**

The library source subdirectory.
The structure for this subdirectory
is covered in detail
[below](#library-source).

**app**

The application target subdirectory.  The actual name of this directory
is configurable in the CMakeLists.txt file.  This subdirectory should
contain a CMakeLists.txt file that add whatever cmake targets are needed
for the specific application.

**doc**

The documentation subdirectory.  This subdirectory should contain configuration
files for cinch-generated [guide documentation](#guide-documentation), and
for [doxygen interface documentation](#interface-documentation).

**cinch**

The cinch subdirectory.  This should be checked-out from the cinch
git server: 'git clone git@darwin.lanl.gov:cinch.git'.

## Library Source Subdirectory
<a name="library-source"></a>

The library source subdirectory for a cinch project... FIXME

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

# Command-Line Options

Cinch provides various command-line options that may be passed on the cmake
configuration line to affect its behavior.

## Project Version: CINCH\_STATIC\_VERSION (default OFF)

Cinch can automatically create version information for projects that use git.
This feature uses the 'git describe' function, which creates a version from
the most recent annotated tag with a patch level based on the number of
commits since that tag and a partial hash key.  For example, if the most
recent annotated tag is "1.0" and there have been 35 commits since, the
cinch-created version would be similar to: 1.0-35-g2f657a

For new releases, this approach may not be optimal.  In this case, cinch
allows you to override the automatic versioning by specifying a static version
to cmake via the CINCH\_STATIC\_VERSION option.  Simply set this to the
desired version and it will be used.

## Unit Tests with GoogleTest: ENABLE\_UNIT\_TESTS (default OFF)

Cinch has support for unit testing using a combination of CTest
(the native CMake testing facility) and GoogleTest (for C++ support).
If unit tests are enabled, cinch will create a 'test' target.  Unit tests
may be added in any subdirectory of the project simply be creating the
test source code and adding a target using the
'cinch\_add\_unit(target [source list])' function.

Cinch will check for a local GoogleTest installation on the system during
the Cmake configuration step.  If GoogleTest is not found, it will be
built by cinch (GoogleTest source code is included with cinch).

## Guide Documentation: ENABLE\_DOCUMENTATION (default OFF)
<a name="guide-documentation"></a>

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

## Doxygen Documentation: ENABLE\_DOXYGEN (default OFF)
<a name="interface-documentation"></a>

Cinch supports interface documentation using Doxygen.  The doxygen
configuration file should be called 'doxygen.conf.in' and should reside
in the 'doc' subdirectory.  For documentation on using Doxygen, please
take a look at the [Doxygen Homepage](http://www.doxygen.org).
