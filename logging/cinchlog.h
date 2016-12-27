/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2016 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#ifndef cinch_cinchlog_h
#define cinch_cinchlog_h

#if defined __GNUC__
#include <cxxabi.h>
#include <execinfo.h>
#endif // __GNUC__

#include <cassert>
#include <cstdlib>
#include <time.h>

#include <bitset>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <memory>
#include <sstream>
#include <unordered_map>
#include <utility>
#include <vector>

///
/// \file
/// \date Initial file creation: Dec 15, 2016
///

//----------------------------------------------------------------------------//
// Runtime configuration parameters.
//----------------------------------------------------------------------------//

// Set CLOG_ENABLE_STDLOG to enable output to std::clog

// Set CLOG_ENABLE_TAGS to enable tag groups
// Set CLOG_TAG_BITS to enable TAG_BITS number of groups

#ifndef CLOG_TAG_BITS
#define CLOG_TAG_BITS 32
#endif

//----------------------------------------------------------------------------//
// Compile-time configuration parameters.
//----------------------------------------------------------------------------//

// Set the default strip level. All severity levels that are strictly
// less than hte strip level will be stripped...
//
// TRACE 0
// INFO  1
// WARN  2
// ERROR 3
// FATAL 4
//

#ifndef CLOG_STRIP_LEVEL
#define CLOG_STRIP_LEVEL 0
#endif

//----------------------------------------------------------------------------//
// Set color output macros depending on whether or not CLOG_COLOR_OUTPUT
// is defined.
//----------------------------------------------------------------------------//

#ifndef CLOG_COLOR_OUTPUT

#define COLOR_BLACK ""
#define COLOR_DKGRAY ""
#define COLOR_RED ""
#define COLOR_LTRED ""
#define COLOR_GREEN ""
#define COLOR_LTGREEN ""
#define COLOR_BROWN ""
#define COLOR_YELLOW ""
#define COLOR_BLUE ""
#define COLOR_LTBLUE ""
#define COLOR_PURPLE ""
#define COLOR_LTPURPLE ""
#define COLOR_CYAN ""
#define COLOR_LTCYAN ""
#define COLOR_LTGRAY ""
#define COLOR_WHITE ""
#define COLOR_PLAIN ""

#define OUTPUT_BLACK(s) s
#define OUTPUT_DKGRAY(s) s
#define OUTPUT_RED(s) s
#define OUTPUT_LTRED(s) s
#define OUTPUT_GREEN(s) s
#define OUTPUT_LTGREEN(s) s
#define OUTPUT_BROWN(s) s
#define OUTPUT_YELLOW(s) s
#define OUTPUT_BLUE(s) s
#define OUTPUT_LTBLUE(s) s
#define OUTPUT_PURPLE(s) s
#define OUTPUT_LTPURPLE(s) s
#define OUTPUT_CYAN(s) s
#define OUTPUT_LTCYAN(s) s
#define OUTPUT_LTGRAY(s) s
#define OUTPUT_WHITE(s) s

#else

#define COLOR_BLACK    "\033[0;30m"
#define COLOR_DKGRAY   "\033[1;30m"
#define COLOR_RED      "\033[0;31m"
#define COLOR_LTRED    "\033[1;31m"
#define COLOR_GREEN    "\033[0;32m"
#define COLOR_LTGREEN  "\033[1;32m"
#define COLOR_BROWN    "\033[0;33m"
#define COLOR_YELLOW   "\033[1;33m"
#define COLOR_BLUE     "\033[0;34m"
#define COLOR_LTBLUE   "\033[1;34m"
#define COLOR_PURPLE   "\033[0;35m"
#define COLOR_LTPURPLE "\033[1;35m"
#define COLOR_CYAN     "\033[0;36m"
#define COLOR_LTCYAN   "\033[1;36m"
#define COLOR_LTGRAY   "\033[0;37m"
#define COLOR_WHITE    "\033[1;37m"
#define COLOR_PLAIN    "\033[0m"

#define OUTPUT_BLACK(s) COLOR_BLACK << s << COLOR_PLAIN
#define OUTPUT_DKGRAY(s) COLOR_DKGRAY << s << COLOR_PLAIN
#define OUTPUT_RED(s) COLOR_RED << s << COLOR_PLAIN
#define OUTPUT_LTRED(s) COLOR_LTRED << s << COLOR_PLAIN
#define OUTPUT_GREEN(s) COLOR_GREEN << s << COLOR_PLAIN
#define OUTPUT_LTGREEN(s) COLOR_LTGREEN << s << COLOR_PLAIN
#define OUTPUT_BROWN(s) COLOR_BROWN << s << COLOR_PLAIN
#define OUTPUT_YELLOW(s) COLOR_YELLOW << s << COLOR_PLAIN
#define OUTPUT_BLUE(s) COLOR_BLUE << s << COLOR_PLAIN
#define OUTPUT_LTBLUE(s) COLOR_LTBLUE << s << COLOR_PLAIN
#define OUTPUT_PURPLE(s) COLOR_PURPLE << s << COLOR_PLAIN
#define OUTPUT_LTPURPLE(s) COLOR_LTPURPLE << s << COLOR_PLAIN
#define OUTPUT_CYAN(s) COLOR_CYAN << s << COLOR_PLAIN
#define OUTPUT_LTCYAN(s) COLOR_LTCYAN << s << COLOR_PLAIN
#define OUTPUT_LTGRAY(s) COLOR_LTGRAY << s << COLOR_PLAIN
#define OUTPUT_WHITE(s) COLOR_WHITE << s << COLOR_PLAIN

#endif // CLOG_COLOR_OUTPUT

//----------------------------------------------------------------------------//
// Macro utilities.
//----------------------------------------------------------------------------//

#define _clog_util_stringify(s) #s
#define _clog_stringify(s) _clog_util_stringify(s)
#define clog_concat(a, b) a ## b

namespace cinch {

//----------------------------------------------------------------------------//
// Helper functions.
//----------------------------------------------------------------------------//

inline
std::string
demangle(
  const char * name
)
{
#if defined __GNUC__
  int status = -4;

  std::unique_ptr<char, void(*)(void*)> res {
    abi::__cxa_demangle(name, NULL, NULL, &status), std::free };

  return (status==0) ? res.get() : name ;
#else
  return name;
#endif
} // demangle

inline
std::string
timestamp(bool underscores = false)
{
  char stamp[14];
  time_t t = time(0);
  std::string format = underscores ? "%m%d_%H%M%S" : "%m%d %H:%M:%S";
  strftime(stamp, sizeof(stamp), format.c_str(), localtime(&t));
  return std::string(stamp);
} // timestamp

template<char C>
std::string rstrip(const char *file) {
  std::string tmp(file);
  return tmp.substr(tmp.rfind(C)+1);
} // rstrip

//----------------------------------------------------------------------------//
// Auxilliary types.
//----------------------------------------------------------------------------//

///
/// Stream buffer type to allow output to multiple targets
/// a la the tee function.
///
class tee_buffer_t
  : public std::streambuf
{
public:

  ///
  /// Buffer data type to hold state and actual low-level
  /// stream buffer pointer.
  ///
  struct buffer_data_t {
    bool enabled;
    bool colorized;
    std::streambuf * buffer;
  }; // struct buffer_data_t

  ///
  /// Add a buffer to which output should be written. This also enables
  /// the buffer, i.e., output will be written to it.
  ///
  void
  add_buffer(
    std::string key,
    std::streambuf * sb,
    bool colorized
  )
  {
    buffers_[key].enabled = true;
    buffers_[key].buffer = sb;
    buffers_[key].colorized = colorized;
  } // add_buffer

  ///
  /// Enable a buffer so that output is written to it. This is mainly
  /// for buffers that have been disabled and need to be re-enabled.
  ///
  bool
  enable_buffer(
    std::string key
  )
  {
    buffers_[key].enabled = true;
    return buffers_[key].enabled;
  } // enable_buffer

  ///
  /// Disable a buffer so that output is not written to it.
  ///
  bool
  disable_buffer(
    std::string key
  )
  {
    buffers_[key].enabled = false;
    return buffers_[key].enabled;
  } // disable_buffer

protected:

  ///
  /// Override the overflow method. This streambuf has no buffer, so overflow
  /// happens for every character that is written to the string, allowing
  /// us to write to multiple output streams. This method also detects
  /// colorization strings embedded in the character stream and removes
  /// them from output that is going to non-colorized buffers.
  ///
  /// \param c The character to write. This is passed in as an int so that
  ///          non-characters like EOF can be written to the stream.
  ///
  virtual
  int
  overflow(
    int c
  )
  {
    if(c == EOF) {
      return !EOF;
    }
    else {
      // Get the size before we add the current character
      const size_t tbsize = test_buffer_.size();

      // Buffer the output for now...
      test_buffer_.append(1, c);

      switch(tbsize) {

        case 0:
          if(c == '\033') {
            // This could be a color string, start buffering
            return c;
          }
          else {
            // No match, go ahead and write the character
            return flush_buffer(all_buffers);
          } // if

        case 1:
          if(c == '[') {
            // This still looks like a color string, keep buffering
            return c;
          }
          else {
            // This is some other kind of escape. Write the
            // buffered output to all buffers.
            return flush_buffer(all_buffers);
          } // if

        case 2:
          if(c == '0' || c == '1') {
            // This still looks like a color string, keep buffering
            return c;
          }
          else {
            // This is some other kind of escape. Write the
            // buffered output to all buffers.
            return flush_buffer(all_buffers);
          } // if

        case 3:
          if(c == ';') {
            // This still looks like a color string, keep buffering
            return c;
          }
          else if(c == 'm') {
            // This is a pain color termination. Write the
            // buffered output to the color buffers.
            return flush_buffer(color_buffers);
          }
          else {
            // This is some other kind of escape. Write the
            // buffered output to all buffers.
            return flush_buffer(all_buffers);
          } // if

        case 4:
          if(c == '3') {
            // This still looks like a color string, keep buffering
            return c;
          }
          else {
            // This is some other kind of escape. Write the
            // buffered output to all buffers.
            return flush_buffer(all_buffers);
          } // if

        case 5:
          if(isdigit(c) && (c - '0') < 8) {
            // This still looks like a color string, keep buffering
            return c;
          }
          else {
            // This is some other kind of escape. Write the
            // buffered output to all buffers.
            return flush_buffer(all_buffers);
          } // if

        case 6:
          if(c == 'm') {
            // This is a color string termination. Write the
            // buffered output to the color buffers.
            return flush_buffer(color_buffers);
          }
          else {
            // This is some other kind of escape. Write the
            // buffered output to all buffers.
            return flush_buffer(all_buffers);
          } // if
      } // switch
      return c;
    } // if
  } // overflow

  ///
  /// Override the sync method so that we sync all of the output buffers.
  ///
  virtual
  int
  sync()
  {
    int state = 0;

    for(auto b: buffers_) {
      const int s = b.second.buffer->pubsync();
      state = (state != 0) ? state : s;
    } // for

    // Return -1 if one of the buffers had an error
    return (state == 0) ? 0 : -1;
  } // sync

private:

  // Predicate to select all buffers.
  static
  bool
  all_buffers(
    const buffer_data_t & bd
  )
  {
    return bd.enabled;
  } // any_buffer

  // Predicate to select color buffers.
  static
  bool
  color_buffers(
    const buffer_data_t & bd
  )
  {
    return bd.enabled && bd.colorized;
  } // any_buffer

  // Flush buffered output to buffers that satisfy the predicate function.
  template<typename P>
  int
  flush_buffer(P && predicate = all_buffers)
  {
    int eof = !EOF;

    // Put test buffer characters to each buffer
    for(auto b: buffers_) {
      if(predicate(b.second)) {
        for(auto bc: test_buffer_) {
          const int w = b.second.buffer->sputc(bc);
          eof = (eof == EOF) ? eof : w;
        } // for
      } // if
    } // for
    
    // Clear the test buffer
    test_buffer_.clear();

    // Return EOF if one of the buffers hit the end
    return eof == EOF ? EOF : !EOF;
  } // flush_buffer

  std::unordered_map<std::string, buffer_data_t> buffers_;
  std::string test_buffer_;

}; // class tee_buffer_t

///
/// A stream class that writes to multiple output buffers.
///
struct tee_stream_t
  : public std::ostream
{

  tee_stream_t()
  :
    std::ostream(&tee_)
  {
    // Allow users to turn std::clog output on and off from
    // their environment.
    if(const char * env = std::getenv("CLOG_ENABLE_STDLOG")) {
      tee_.add_buffer("clog", std::clog.rdbuf(), true);
    } // if
  } // tee_stream_t

  tee_stream_t &
  operator * ()
  {
    return *this;
  } // operator *

  ///
  /// Add a new buffer to the output.
  ///
  void
  add_buffer(
    std::string key,
    std::ostream & s,
    bool colorized = false
  )
  {
    tee_.add_buffer(key, s.rdbuf(), colorized);
  } // add_buffer

  ///
  /// Enable an existing buffer.
  ///
  /// \param[in] key The string identifier of the streambuf.
  ///
  bool
  enable_buffer(
    std::string key
  )
  {
    tee_.enable_buffer(key);
    return true;
  } // enable_buffer

  ///
  /// Disable an existing buffer.
  ///
  /// \param[in] key The string identifier of the streambuf.
  ///
  bool
  disable_buffer(
    std::string key
  )
  {
    tee_.disable_buffer(key);
    return false;
  } // disable_buffer

private:

  tee_buffer_t tee_;

}; // struct tee_stream_t

//----------------------------------------------------------------------------//
// Management type.
//----------------------------------------------------------------------------//

///
/// \class clog_t cinchlog.h
/// \brief clog_t provides access to logging parameters and configuration.
///
/// This type provides access to the underlying logging parameters for
/// configuration and information. The cinch logging functions provide
/// basic logging with an interface that is similar to Google's GLOG
/// and the Boost logging utilities.
///
/// \note We may want to consider adopting one of these packages
/// in the future.
///
class clog_t
{
public:

  /// Copy constructor (disabled)
  clog_t(const clog_t &) = delete;

  /// Assignment operator (disabled)
  clog_t & operator = (const clog_t &) = delete;

  ///
  /// Meyer's singleton instance.
  ///
  /// \return The singleton instance of this type.
  ///
  static
  clog_t &
  instance()
  {
    static clog_t c;
    return c;
  } // instance

  ///
  ///
  ///
  void
  init(std::string groups = "all")
  {
    // Because active tags are specified at runtime, it is
    // necessary to maintain a map of the compile-time registered
    // tag names to the id that they get assigned after the clog_t
    // initialzation (register_tag). This map will be used to populate
    // the tag_bitset_ for fast runtime comparisons of enabled tag groups.

    // Note: For the time being, the map uses actual strings rather than
    // hashes. We should consider creating a const_string_t type for
    // constexpr string creation.

    if(groups != "all") {
      // Set all of the bits to false, then go through the tags
      // that were specified by the user.
      tag_bitset_.reset();

      // The default group is always active (unscoped)
      tag_bitset_.set(0);

      std::istringstream is(groups);
      std::string tag;
      while(std::getline(is, tag, ',')) {
        if(tag_map_.find(tag) != tag_map_.end()) {
#if 0
          std::cout << "Enabling tag group " << tag << std::endl;
#endif
          tag_bitset_.set(tag_map_[tag]);
        }
        else {
          std::cerr << "CLOG WARNING: " << tag <<
            " has not been registered. Ignoring this group..." << std::endl;
        } // if
      } // while
    }
    else {
      // This is the default: All tags are active, so we set all
      // of the bits to true.
      tag_bitset_.reset().flip();
    } // if
  } // clog_t

  ///
  /// Return the log stream.
  ///
  std::ostream &
  stream()
  {
    return *stream_;
  } // stream

  ///
  /// Return a null stream to disable output.
  ///
  std::ostream &
  null_stream()
  {
    return null_stream_;
  } // null_stream

  ///
  /// Return the tee stream to allow the user to set configuration options.
  /// FIXME: Need a better interface for this...
  ///
  tee_stream_t &
  config_stream()
  {
    return *stream_;
  } // stream

  ///
  /// Return the next tag id.
  ///
  size_t
  register_tag(const char * name)
  {
    const size_t id = ++tag_id_;
    assert(id < CLOG_TAG_BITS && "Tag bits overflow! Increase CLOG_TAG_BITS");
    tag_map_[name] = id;
    return id;
  } // next_tag

  ///
  /// Return a reference to the active tag (const version).
  ///
  const size_t &
  active_tag() const
  {
    return active_tag_;
  } // active_tag

  ///
  /// Return a reference to the active tag (mutable version).
  ///
  size_t &
  active_tag()
  {
    return active_tag_;
  } // active_tag

  bool
  tag_enabled()
  {
#if defined(CLOG_ENABLE_TAGS)
    return tag_bitset_.test(active_tag_);
#else
    return true;
#endif // CLOG_ENABLE_TAGS
  } // tag_enabled

private:

  ///
  /// Constructor. This method is hidden because we are a singleton.
  ///
  clog_t()
  :
    null_stream_(0), tag_id_(0), active_tag_(0)
  {
  } // clog_t

  ~clog_t() {}

  tee_stream_t stream_;
  std::ostream null_stream_;

  size_t tag_id_;
  size_t active_tag_;
  std::bitset<CLOG_TAG_BITS> tag_bitset_;
  std::unordered_map<std::string, size_t> tag_map_;

}; // class clog_t

//----------------------------------------------------------------------------//
// Tag scope.
//----------------------------------------------------------------------------//

///
/// \class clog_tag_scope_t
/// \brief clog_tag_scope_t provides an execution scope for which a given
///        tag id is active.
///
/// This type sets the active tag id to the id passed to the constructor,
/// stashing the current active tag. When the instance goes out of scope,
/// the active tag is reset to the stashed value.
///
struct clog_tag_scope_t
{
  clog_tag_scope_t(size_t tag = 0)
  :
    stash_(clog_t::instance().active_tag())
  {
    clog_t::instance().active_tag() = tag;
  } // clog_tag_scope_t

  ~clog_tag_scope_t()
  {
    clog_t::instance().active_tag() = stash_;
  } // ~clog_tag_scope_t

private:

  size_t stash_;

}; // clog_tag_scope_t

// Note that none of the tag interface is thread safe. This will have
// to be fixed in the future. One way to do this would be to use TLS
// for the active tag information.
//
// Another feature that would be nice is if the static size_t definition
// failed with helpful information if the user tries to create a tag
// scope for a tag that hasn't been registered.

// Register a tag group with the runtime (clog_t). We need the static
// size_t so that tag scopes can be created quickly during execution.
#define clog_register_tag(name)                                                \
  static size_t name ## _clog_tag_id =                                         \
  cinch::clog_t::instance().register_tag(_clog_stringify(name));

// Return the static variable created in the clog_register_tag macro above.
#define clog_tag_lookup(name)                                                  \
  name ## _clog_tag_id

// Create a new tag scope.
#define clog_tag_scope(name)                                                   \
  cinch::clog_tag_scope_t name ## _clog_tag_scope__(clog_tag_lookup(name));

//----------------------------------------------------------------------------//
// Base type for log messages.
//----------------------------------------------------------------------------//

///
/// Function always returning true. Used for defaults.
///
inline
bool
true_state()
{
  return true;
} // output_bool

///
/// \struct log_message_t cinchlog.h
/// \brief log_message_t provides a base class for implementing
///        formatted logging utilities.
///
template<typename P>
struct log_message_t
{
  ///
  /// Constructor.
  ///
  /// This method initializes the \e fatal_ data member to false. Derived
  /// classes wishing to force exit should set this to true in their
  /// override of the stream method.
  ///
  /// \tparam P Predicate funtion type.
  ///
  /// \param file The current file (where the log message was created).
  ///             In general, this will always use the __FILE__ parameter
  ///             from the calling macro.
  /// \param line The current line (where the log message was called).
  ///             In general, this will always use the __LINE__ parameter
  ///             from the calling macro.
  /// \param predicate The predicate function to determine whether or not
  ///                  the calling runtime should produce output.
  ///
  log_message_t(
    const char * file,
    int line,
    P && predicate
  )
  :
    file_(file), line_(line), predicate_(predicate), fatal_(false)
  {
  } // log_message_t

  virtual
  ~log_message_t()
  {
    if(fatal_ && predicate_()) {

      // Create a backtrace.
      // This is only defined for platforms that have glibc.
#if defined __GNUC__
      void * array[100];
      size_t size;

      size = backtrace(array, 100);
      char ** symbols = backtrace_symbols(array, size);

      std::ostream & stream = clog_t::instance().stream();

      for(size_t i(0); i<size; ++i) {
        std::string re = symbols[i];

        // Look for a mangled name
        auto start = re.find_first_of('(');
        auto end = re.find_first_of('+');

        std::string symbol;

        if(start != std::string::npos && end != std::string::npos) {
          symbol = re.substr(0, start+1) +
            demangle(re.substr(start+1, end-1-start).c_str()) +
            re.substr(end, re.size());
        }
        else {
          symbol = re;
        } // if

        // Output the demangled result
        stream << symbol << std::endl;
      } // for
#endif

      // Exit with error condition.
      std::exit(1);
    } // if
  } // ~log_message_t

  ///
  /// Return the output stream. Override this method to add additional
  // formatting to a particular severity output.
  ///
  virtual
  std::ostream &
  stream()
  {
    return predicate_() ? clog_t::instance().stream() :
      clog_t::instance().null_stream();
  } // stream

protected:

  const char * file_;
  int line_;
  P & predicate_;
  bool fatal_;

}; // struct log_message_t

//----------------------------------------------------------------------------//
// Convenience macro to define severity levels.
//
// Log message types defined using this macro always use the default
// predicate function, true_state().
//----------------------------------------------------------------------------//

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

severity_message_t(info, decltype(cinch::true_state),
  {
#if CLOG_STRIP_LEVEL < 2
    if(clog_t::instance().tag_enabled() && predicate_()) {
      std::ostream & stream = clog_t::instance().stream();
      stream << OUTPUT_GREEN("[I") << OUTPUT_LTGRAY(message_stamp);
      stream << OUTPUT_GREEN("] ");
      return stream;
    }
    else {
      return clog_t::instance().null_stream();
    } // if
#else
    return clog_t::instance().null_stream();
#endif
  });

severity_message_t(warn, decltype(cinch::true_state),
  {
#if CLOG_STRIP_LEVEL < 3
    if(clog_t::instance().tag_enabled() && predicate_()) {
      std::ostream & stream = clog_t::instance().stream();
      stream << OUTPUT_BROWN("[W") << OUTPUT_LTGRAY(message_stamp);
      stream << OUTPUT_BROWN("] ") << COLOR_YELLOW;
      return stream;
    }
    else {
      return clog_t::instance().null_stream();
    } // if
#else
    return clog_t::instance().null_stream();
#endif
  });

severity_message_t(error, decltype(cinch::true_state),
  {
#if CLOG_STRIP_LEVEL < 4
    if(clog_t::instance().tag_enabled() && predicate_()) {
      std::ostream & stream = clog_t::instance().stream();
      stream << OUTPUT_RED("[E") << OUTPUT_LTGRAY(message_stamp);
      stream << OUTPUT_RED("] ") << COLOR_LTRED;
      return stream;
    }
    else {
      return clog_t::instance().null_stream();
    } // if
#else
    return clog_t::instance().null_stream();
#endif
  });

// FIXME: This probably does not have the behavior we want, i.e.,
//        fatal errors should not be predicated.
severity_message_t(fatal, decltype(cinch::true_state),
  {
#if CLOG_STRIP_LEVEL < 5
    if(clog_t::instance().tag_enabled() && predicate_()) {
      std::ostream & stream = clog_t::instance().stream();
      stream << OUTPUT_RED("[F" << message_stamp << "] ") << COLOR_LTRED;
      fatal_ = true;
      return stream;
    }
    else {
      return clog_t::instance().null_stream();
    } // if
#else
    return clog_t::instance().null_stream();
#endif
  });

} // namespace cinch

//----------------------------------------------------------------------------//
// Macro Interface
//----------------------------------------------------------------------------//

#define clog_init(groups)                                                      \
  cinch::clog_t::instance().init(groups)

///
/// This handles all of the different logging modes for the insertion
/// style logging interface.
///
/// \param severity The severity level of the log entry.
///
/// \note The form "true && ..." is necessary for tertiary argument
///       evaluation so that the std::ostream & returned by the stream()
///       function can be implicitly converted to an int.
///
#define clog(severity)                                                         \
  true && cinch::severity ## _log_message_t(__FILE__, __LINE__).stream()

///
/// Method style interface for trace level severity log entries.
///
#define clog_trace(message)                                                    \
  clog(trace) << message << std::endl

///
/// Method style interface for info level severity log entries.
///
#define clog_info(message)                                                     \
  clog(info) << message << std::endl

///
/// Method style interface for warn level severity log entries.
///
#define clog_warn(message)                                                     \
  clog(warn) << message << std::endl

///
/// Method style interface for error level severity log entries.
///
#define clog_error(message)                                                    \
  clog(error) << message << std::endl

/// Indirection to expand counter name.
#define clog_counter_varname(str, line)                                        \
  clog_concat(str, line)

/// Indirection to expand counter name.
#define clog_counter(str)                                                      \
  clog_counter_varname(str, __LINE__)

/// Define a counter name.
#define counter_name clog_counter(counter)

///
/// Method style interface to output every nth iteration.
///
#define clog_every_n(severity, n, message)                                     \
  static size_t counter_name = 0;                                              \
  if(counter_name++%n == 0) { clog_ ## severity(message); }

///
/// Method style interface for fatal level severity log entries.
///
#define clog_fatal(message)                                                    \
  clog(fatal) << message << std::endl

///
/// Assertion with error message.
///
#define clog_assert(test, message)                                             \
  !(test) && clog_fatal(message)

///
/// Expose interface to add buffers. Added buffers are enabled 
/// by default.
///
#define clog_add_buffer(name, ostream, colorized)                              \
  cinch::clog_t::instance().config_stream().add_buffer(name, ostream,          \
    colorized)

///
/// Expose interface to enable buffers.
///
#define clog_enable_buffer(name)                                               \
  cinch::clog_t::instance().config_stream().enable_buffer(name)

///
/// Expose interface to disable buffers.
///
#define clog_disable_buffer(name)                                              \
  cinch::clog_t::instance().config_stream().disable_buffer(name)

namespace clog {

  ///
  // Enum type to specify output delimiters for containers.
  ///
  enum clog_delimiters_t : size_t {
    newline,
    space,
    colon,
    semicolon,
    comma
  };

} // namespace

///
/// Output contents of a container.
///
#define clog_container(severity, banner, container, delimiter)                 \
  {                                                                            \
  std::stringstream ss;                                                        \
  char delim =                                                                 \
    (delimiter == clog::newline) ?                                             \
      '\n' :                                                                   \
    (delimiter == clog::space) ?                                               \
      ' ' :                                                                    \
    (delimiter == clog::colon) ?                                               \
      ':' :                                                                    \
    (delimiter == clog::semicolon) ?                                           \
      ';' :                                                                    \
      ',';                                                                     \
  ss << banner << (delimiter == clog::newline ? '\n' : ' ');                   \
  size_t entry(0);                                                             \
  for(auto c = container.begin(); c != container.end(); ++c) {                 \
    (delimiter == clog::newline) &&                                            \
    ss << OUTPUT_CYAN("[C") << OUTPUT_LTGRAY(" entry ") <<                     \
      entry++ << OUTPUT_CYAN("]") << std::endl << *c;                          \
    (c != --container.end()) && ss << delim;                                   \
  }                                                                            \
  clog(severity) << ss.str() << std::endl;                                     \
  }

// Enable MPI
#if defined(CLOG_ENABLE_MPI)

#include <mpi.h>

namespace cinch {

struct mpi_config_t {

  static
  mpi_config_t &
  instance()
  {
    static mpi_config_t m;
    return m;
  } // instance

  const
  size_t &
  active_rank() const
  {
    return active_rank_;
  } // active_rank

  size_t &
  active_rank()
  {
    return active_rank_;
  } // active_rank

private:

  mpi_config_t()
  :
    active_rank_(0)
  {}

  size_t active_rank_;

}; // struct mpi_config_t

template<
  size_t R
>
inline
bool
is_static_rank()
{
  int part;
  MPI_Comm_rank(MPI_COMM_WORLD, &part);
  return part == R;
} // is_static_rank

// FIXME: Not sure if I like this approach...
inline
bool
is_active_rank()
{
  int part;
  MPI_Comm_rank(MPI_COMM_WORLD, &part);
  return part == mpi_config_t::instance().active_rank();
} // is_active_rank

} // namespace

///
/// This handles all of the different logging modes for the insertion
/// style logging interface for MPI runtime logging.
///
/// \param severity The severity level of the log entry.
///
/// \note The form "true && ..." is necessary for tertiary argument
///       evaluation so that the std::ostream & returned by the stream()
///       function can be implicitly converted to an int.
///
#define clog_rank(severity, rank)                                              \
  true && cinch::severity ## _log_message_t(__FILE__, __LINE__,                \
    cinch::is_static_rank<rank>).stream()

// FIXME: Not sure if I like this approach...
#define clog_set_output_rank(rank)                                             \
  cinch::mpi_config_t::instance().active_rank() = rank

// FIXME: Not sure if I like this approach...
#define clog_one(severity)                                                     \
  true && cinch::severity ## _log_message_t(__FILE__, __LINE__,                \
    cinch::is_active_rank).stream()

///
/// Output contents of a container only on the specified rank.
///
#define clog_container_rank(severity, banner, container, delimiter, rank)      \
  {                                                                            \
  std::stringstream ss;                                                        \
  char delim =                                                                 \
    (delimiter == clog::newline) ?                                             \
      '\n' :                                                                   \
    (delimiter == clog::space) ?                                               \
      ' ' :                                                                    \
    (delimiter == clog::colon) ?                                               \
      ':' :                                                                    \
    (delimiter == clog::semicolon) ?                                           \
      ';' :                                                                    \
      ',';                                                                     \
  ss << banner << (delimiter == clog::newline ? '\n' : ' ');                   \
  size_t entry(0);                                                             \
  for(auto c = container.begin(); c != container.end(); ++c) {                 \
    (delimiter == clog::newline) &&                                            \
    ss << OUTPUT_CYAN("[C") << OUTPUT_LTGRAY(" entry ") <<                     \
      entry++ << OUTPUT_CYAN("]") << std::endl << *c;                          \
    (c != --container.end()) && ss << delim;                                   \
  }                                                                            \
  clog_rank(severity, rank) << ss.str() << std::endl;                          \
  }

#else

#define clog_rank(severity, rank)                                              \
  std::cout

#define clog_set_output_rank(rank)

#define clog_one(severity)                                                     \
  std::cout

#define clog_container_rank(severity, banner, container, delimiter, rank)      \
  std::cout

#endif // CLOG_ENABLE_MPI

#endif // cinch_cinchlog_h

/*~-------------------------------------------------------------------------~-*
 * Formatting options for vim.
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~-------------------------------------------------------------------------~-*/
