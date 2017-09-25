# Cinch: Logging
<!--
  The above header ("Cinch: Logging") is required for Doxygen to
  correctly name the auto-generated page. It is ignored in the FleCSI
  guide documentation.
-->

<!-- CINCHDOC DOCUMENT(User Guide) SECTION(CLOG) -->

## Cinch Logging Utilities (CLOG)

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

### Build Options

***CMake Option:*** **ENABLE_CLOG (default OFF)**

***CMake Option:*** **CLOG_COLOR_OUTPUT (default ON)**

***CMake Option:*** **CLOG_DEBUG (default OFF)**

***CMake Option:*** **CLOG_ENABLE_EXTERNAL (default OFF)**

***CMake Option:*** **CLOG_ENABLE_MPI (default OFF)**

***CMake Option:*** **CLOG_ENABLE_TAGS (default OFF)**

***CMake Option:*** **CLOG_STRIP_LEVEL (default "0")**

***CMake Option:*** **CLOG_TAG_BITS (default "64")**

### CLOG Interface Macros

The CLOG interface is documented in [modules](modules.html).

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

<!-- vim: set tabstop=2 shiftwidth=2 expandtab fo=cqt tw=72 : -->
