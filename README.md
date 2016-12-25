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

## Cinch Logging Utilities (CLOG)

### Options

***CMake Option:*** **CLOG_ENABLE_STDLOG (default OFF)**

***CMake Option:*** **CLOG_STRIP_LEVEL (default "0")**

***CMake Option:*** **CLOG_TAG_BITS (default "16")**

***CMake Option:*** **CLOG_COLOR_OUTPUT (default OFF)**

### Basic Description

Cinch has support for trace, info, warn, error, and fatal log reporting
(similar to Google Log). There are two interface styles for logging
information using CLOG: Insertion style, e.g.,

```cpp
clog(info) << "This is some information" << std::endl;
```

and a method interface, e.g.,

```cpp
clog_info("This is some information");
```

Both interface styles are available for all severity levels (discussed
below).

**NOTE:** CLOG is automatically available for Cinch unit tests.

### CLOG Interface Macros

* **clog_init(groups)**  
Initialize the CLOG runtime, enabling the tag groups specified in
*groups*, e.g.,
```cpp
clog_init("group1,group2,group3");
```

* **clog(severity)**  
Insertion style output with severity level *severity*, e.g.,
```cpp
clog(error) << "This is an error level severity message" << std::endl;
```

* **clog_severity(message)**  
Method style output with severity level *severity* and output message
*message*. Note that *message* can be any valid C++ stream, e.g.,
```cpp
clog_info("The number is " << number);
```

* **clog_assert(test, message)**  
Assert that *test* is true. If *test* is false, this call will
execute *clog_fatal(message)*.

* **clog_add_buffer(name, ostream, colorized)**  
Add the buffer defined by the *ostream* argument in rdbuf(). The second
parameter *name* is the string name to associate with the buffer, and
can be used in subsequent calls to the CLOG buffer interface. The last
parameter indicates whether or not the buffer supports color output.

* **clog_enable_buffer(name)**  
Enable the buffer identified by *name*.

* **clog_disable_buffer(name)**  
Disable the buffer identified by *name*.

### Controlling CLOG Output: Output Streams

CLOG can write output to multiple output streams at once.  Users can
control which CLOG log files and output are created by adding and
enabling/disabling various output streams. By default, CLOG directs
output to std::clog (this is the default C++ log iostream and is not
part of CLOG) when the **CLOG_ENABLE_STDLOG** environment variable is
defined. Other output streams must be added by the user application. As
an example, if the user application wanted CLOG output to go to a file
named *output.log*, one could do the following:

```cpp
#include <ofstream>

#include "cinchlog.h"

int main(int argc, char ** argv) {

  // Initialize CLOG with output for all tag groups (discussed below)
  clog_init("all");

  // Open an output stream for "output.log"
  std::ofstream output("output.log");

  // Add the stream to CLOG:
  // param 1 ("output") The string name of the buffer.
  // param 2 (output)   The stream (CLOG will call stream.rdbuf() on this).
  // param 3 (false)    A boolean denoting whether or not the buffer
  //                    supports colorization.
  //
  // Note that output is automatically enabled for buffers when they
  // are added. Buffers can be disable with clog_disable_buffer(string name),
  // and re-enabled with clog_enable_buffer(string name).
  clog_add_buffer("output", output, false);

  // Write some information to the output file (and to std::clog if enabled)
  clog(info) << "This will go to output.log" << std::endl;

  return 0;
} // main
```

### Controlling CLOG Output: Severity Levels

CLOG output can be controlled at compile time by specifying a particular
severity level. Any logging messages with a lower severity level than
the one specified by **CLOG_STRIP_LEVEL** will be disabled. Note that
this implies that CLOG will produce no output for
**CLOG_STRIP_LEVEL >= 5**.

The different severity levels have the following behavior:

* **trace**  
Enabled only for severity level 0 (less than 1)  
Trace output is suitable for fine-grained logging information.

* **info**  
Enabled for severity levels less than 2  
Info output is suitable for normal logging information.

* **warn**  
Enabled for severity levels less than 3  
Warn output is useful for issuing warnings. When **CLOG_COLOR_OUTPUT**
is enabled, warn messages will be displayed in yellow.

* **error**  
Enabled for severity levels less than 4  
Error output is useful for issuing non-fatal errors. When
**CLOG_COLOR_OUTPUT** is enabled, error messages will be displayed in
red.

* **fatal**  
Enabled for severity levels less than 5  
Fatal error output is useful for issuing fatal errors. Fatal errors
print a message, dump the current stack trace, and call std::exit(1).
When **CLOG_COLOR_OUTPUT** is enabled, fatal messages will be displayed
in red.

### Controlling CLOG Output: Tag Groups

Runtime control of CLOG output is possible by adding scoping sections in
the source code. These are referred to as *tag groups* because the
scoped section is labeled with a tag. The number of possible tag groups
is controlled by **CLOG_TAG_BITS** (default 16).  Tag groups can be
enabled or disabled at runtime by specifying the list of tag groups to
the *clog_init* function. Generally, these are controlled by a
command-line flag that is interpreted by the user's application. Here is
an example code using GFlags to control output:

```cpp
#include <gflags/gflags.h>

// Create a command-line flag "--groups" with default value "all"
DEFINE_string(groups, "all", "Specify the active tag groups");

#include "cinchlog.h"

int main(int argc, char ** argv) {

  // Parse the command-line arguments
  gflags::ParseCommandLineFlags(&argc, &argv, true);

  // If the user has specified tag groups with --groups=group1, ...
  // these groups will be enabled. Recall that the default is "all".
  clog_init(FLAGS_groups);

  {
  // Create a new tag scope. Log messages within this scope will
  // only be output if tag group "tag1" or tag group "all" is enabled.
  clog_tag_scope(tag1);

  clog(info) << "Enabled for tag group tag1" << std::endl;

  clog(warn) << "This is a warning in group tag1" << std::endl;
  } // scope

  {
  // Create a new tag scope. Log messages within this scope will
  // only be output if tag group "tag2" or tag group "all" is enabled.
  clog_tag_scope(tag2);

  clog(info) << "Enabled for tag group tag2" << std::endl;

  clog(error) << "This is an error in group tag2" << std::endl;
  } // scope

  clog(info) << "This output is not scoped" << std::endl;

  return 0;
} // main
```

Example code runs:

```
% ./example --groups=tag1
% [I1225 11:59:59 example.cc:22] Enabled for tag group tag1
% [W1225 11:59:59 example.cc:24] This is a warning in group tag1
% [I1225 11:59:59 example.cc:37] This output is not scoped

% ./example --groups=tag2
% [I1225 11:59:59 example.cc:32] Enabled for tag group tag1
% [E1225 11:59:59 example.cc:34] This is an error in group tag2
% [I1225 11:59:59 example.cc:37] This output is not scoped

% ./example
% [I1225 11:59:59 example.cc:22] Enabled for tag group tag1
% [W1225 11:59:59 example.cc:24] This is a warning in group tag1
% [I1225 11:59:59 example.cc:32] Enabled for tag group tag1
% [E1225 11:59:59 example.cc:34] This is an error in group tag2
% [I1225 11:59:59 example.cc:37] This output is not scoped
```

### Advanced Topics: Predicated Output

The normal CLOG interface is implemented through a set of macros.
Advanced users, who need greater control over CLOG, can create their own
interfaces (macro or otherwise) to directly access the low-level CLOG
interface. Log messages in CLOG derive from the *cinch::log_message_t*
type, which provides a constructor, virtual destructor, and a virtual
stream method:

```cpp
template<typename P>
struct log_message_t
{

  // Constructor:
  // param 1 (file)      The originating file of the message (__FILE__)
  // param 2 (line)      The originating line of the mesasge (__LINE__)
  // param 3 (predicate) A predicate function that can be used to
  //                     control output.
  log_message_t(
    const char * file,
    int line,
    P && predicate
  )
  {
    // See cinchlog.h for implementation.
  } // log_message_t

  // Destructor.
  virtual
  ~log_message_t()
  {
    // See cinchlog.h for implementation.
  } // ~log_message_t

  // Stream method.
  virtual
  std::ostream &
  stream()
  {
    // See cinchlog.h for implementation.
  } // stream

}; // struct log_message_t
```

Users wishing to customize CLOG can change the default behavior by
overriding the virtual methods of this type, and by providing custom
predicates. Much of the basic CLOG functionality is implemented in this
manner, e.g., the following code implements the trace level severity
output:

```cpp
#define severity_message_t(severity, P, format)                                \
struct severity ## _log_message_t                                              \
  : public log_message_t<P>                                                    \
{                                                                              \
  severity ## _log_message_t(                                                  \
    const char * file,                                                         \
    int line,                                                                  \
    P && predicate = true_state)                                               \
    : log_message_t<P>(file, line, predicate) {}                               \
                                                                               \
  ~severity ## _log_message_t()                                                \
  {                                                                            \
    /* Clean colors from the stream */                                         \
    clog_t::instance().stream() << COLOR_PLAIN;                                \
  }                                                                            \
                                                                               \
  std::ostream &                                                               \
  stream() override                                                            \
    /* This is replaced by the scoped logic */                                 \
    format                                                                     \
};

//----------------------------------------------------------------------------//
// Define the insertion style severity levels.
//----------------------------------------------------------------------------//

#define message_stamp \
  timestamp() << " " << rstrip<'/'>(file_) << ":" << line_

severity_message_t(trace, decltype(cinch::true_state),
  {
#if CLOG_STRIP_LEVEL < 1
    if(clog_t::instance().tag_enabled() && predicate_()) {
      std::ostream & stream = clog_t::instance().stream();
      stream << OUTPUT_CYAN("[T") << OUTPUT_LTGRAY(message_stamp);
      stream << OUTPUT_CYAN("] ");
      return stream;
    }
    else {
      return clog_t::instance().null_stream();
    } // if
#else
    return clog_t::instance().null_stream();
#endif
  });
```

Interested users should look at the source code for more examples.

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
