<!-- CINCHDOC DOCUMENT(User Guide) SECTION(CLI) -->

# Cinch Command-Line Interface

Cinch provides an extensible command-line interface for adding
build system utilities, such as source file templates, and documentation
generation.  This utility is written in Python and should be installed
prior to using the Cinch CMake interface in your project.

Documentation on adding new services is [here](ccli/devel.md).

# Features

The Cinch CLI currently provides the current services:

**Note: Help for these services can be displayed by calling:**  

~~~~
    % ccli service --help
~~~~

* **cmake** - Service to generate cmake templates.  
This service will output a CMakeLists.txt template suitable either
for a source subdirectory, or for an application target.  The source
version will be initialized with existing C++ files from the target
directory.

* **cinch** - Service to generate Cinch project skeletons.  
This service will create a new git project and populate it with files
as a starting point for a new Cinch project.

* **brand** - Service to generate project branding.  
This service uses special comment annotation to find-and-replace
header and footer information in source files so that project branding
can be easily updated.  As an example, consider this C++ header comment:
~~~~
    /*~-----------------------------------------------------~*
     * C++ Header
     *~-----------------------------------------------------~*/
~~~~
Notice the tilde character used at the beginning and end of the normal
comment delimiters.  The Cinch branding processor interprets these as
binary strings, taking the last 8 characters before the asterisk on
the first and last lines of the comment.  In binary, this header is
interpreted to have id 1 (00000001).  The branding tool uses this
information (in conjunction with an input file that defines replacement
policies for each id) to replace the interior text with whatever has
been specified in the input file for that particular id.  This allows
easy update of copyright or other header information for all of the
files within a project.  The branding service has support for several
different comment styles, including C++, bash (hash comments), and cmake.

* **unit** - Service to generate unit-test templates.  
This service generates template files that can be used to add new
unit tests.  Current support is only for the Google Test C++ testing
framework.  Other templates will be added as more languages become
supported in Cinch.

* **cc** - Service to generate C++ file templates.  
This service generates template files that can be used to add new
C++ source to a Cinch project.

* **git** - Service to manage git repositories.  
This service provides tools to manage git repositories.  In particular,
one can use this service to maintain mirrors of a principle repository.

* **doc** - Service to generate documentation using Pandoc.  
This service implements a basic parser that can walk a directory hierarchy
and collect distributed markdown/latex documentation that will be combined
into a single document.  Sections for multiple documentation documents
can be maintained within a single file.

<!-- vim: set tabstop=4 shiftwidth=4 expandtab : -->
