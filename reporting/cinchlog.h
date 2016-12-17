/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2015 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#ifndef cinch_cinchlog_h
#define cinch_cinchlog_h

#if defined __GNUG__
#include <cxxabi.h>
#include <execinfo.h>
#endif

#include <fstream>
#include <iostream>
#include <memory>
#include <sstream>
#include <unordered_map>
#include <utility>
#include <vector>

///
// \file cinchlog.h
// \authors bergen
// \date Initial file creation: Dec 15, 2016
///

//----------------------------------------------------------------------------//
// Runtime configuration parameters.
//----------------------------------------------------------------------------//

// Set CLOG_ENABLE_STDLOG to enable output to std::clog

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
// Set color output macros depending on whether or not HAVE_COLOR_OUTPUT
// is defined.
//----------------------------------------------------------------------------//

#ifndef HAVE_COLOR_OUTPUT

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

#endif // HAVE_COLOR_OUTPUT

namespace cinch {

//----------------------------------------------------------------------------//
// Auxilliary types.
//----------------------------------------------------------------------------//

class tee_buffer_t
  : public std::streambuf
{
public:

  struct buffer_data_t {
    bool enabled;
    std::streambuf * buffer;
  }; // struct buffer_data_t

  void
  add_buffer(
    std::string key,
    std::streambuf * sb
  )
  {
    buffers_[key].enabled = true;
    buffers_[key].buffer = sb;
  } // add_buffer

  bool
  enable_buffer(
    std::string key
  )
  {
    buffers_[key].enabled = true;
  } // enable_buffer

  bool
  disable_buffer(
    std::string key
  )
  {
    buffers_[key].enabled = false;
  } // disable_buffer

protected:

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
      int eof = !EOF;

      // Put character to each buffer
      for(auto b: buffers_) {
        const int w = b.second.buffer->sputc(c);
        eof = (eof == EOF) ? eof : w;
      } // for

      // Return EOF if one of the buffers hit the end
      return eof == EOF ? EOF : c;
    } // if
  } // overflow

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

  std::unordered_map<std::string, buffer_data_t> buffers_;

}; // class tee_buffer_t

struct tee_stream_t
  : public std::ostream
{

  tee_stream_t()
  :
    std::ostream(&tee_)
  {
    if(const char * env = std::getenv("CLOG_ENABLE_STDLOG")) {
      tee_.add_buffer("clog", std::clog.rdbuf());
    } // if
  } // tee_stream_t

  tee_stream_t &
  operator * ()
  {
    return *this;
  } // operator *

  void
  add_buffer(
    std::string key,
    std::ostream & s
  )
  {
    tee_.add_buffer(key, s.rdbuf());
  } // add_buffer

private:

  tee_buffer_t tee_;

}; // struct tee_stream_t

//----------------------------------------------------------------------------//
// Management type.
//----------------------------------------------------------------------------//

///
// \class cinchlog_t cinchlog.h
// \brief cinchlog_t provides access to logging parameters and configuration.
//
// This type provides access to the underlying logging parameters for
// configuration and information. The cinch logging functions provide
// basic logging with an interface that is similar to Google's GLOG
// and the Boost logging utilities.
//
// \note We may want to consider adopting one of these packages
// in the future.
///
class cinchlog_t
{
public:

  /// Copy constructor (disabled)
  cinchlog_t(const cinchlog_t &) = delete;

  /// Assignment operator (disabled)
  cinchlog_t & operator = (const cinchlog_t &) = delete;

  ///
  // Meyer's singleton instance.
  //
  // \return The singleton instance of this type.
  ///
  static
  cinchlog_t &
  instance()
  {
    static cinchlog_t c;
    return c;
  } // instance

  ///
  // Return the log stream.
  ///
  std::ostream &
  stream()
  {
    return *stream_;
  } // stream

  std::ostream &
  null_stream()
  {
    return null_stream_;
  } // null_stream

  ///
  // FIXME
  ///
  tee_stream_t &
  config_stream()
  {
    return *stream_;
  } // stream

private:

  ///
  // Constructor. This method is hidden because we are a singleton.
  //
  cinchlog_t()
  :
    null_stream_(0)
  {
  } // cinchlog_t

  ~cinchlog_t() {}

  tee_stream_t stream_;
  std::ostream null_stream_;

}; // class cinchlog_t

//----------------------------------------------------------------------------//
// Base type for log messages.
//----------------------------------------------------------------------------//


std::string
demangle(
  const char * name
)
{
#if defined __GNUG__
  int status = -4;

  std::unique_ptr<char, void(*)(void*)> res {
    abi::__cxa_demangle(name, NULL, NULL, &status), std::free };

  return (status==0) ? res.get() : name ;
#else
	return name;
#endif
} // demangle


///
// \struct log_message_t cinchlog.h
// \brief log_message_t provides a base class for implementing
//        formatted logging utilities.
///
struct log_message_t
{
  ///
  // Constructor.
  //
  // This method initializes the \e fatal_ data member to false. Derived
  // classes wishing to force exit should set this to true in their
  // override of the stream method.
  //
  // \param file The current file (where the log message was created).
  //             In general, this will always use the __FILE__ parameter
  //             from the calling macro.
  // \param line The current line (where the log message was called).
  //             In general, this will always use the __LINE__ parameter
  //             from the calling macro.
  ///
  log_message_t(
    const char * file,
    int line
  )
  :
    file_(file), line_(line), fatal_(false)
  {
  } // log_message_t

  virtual
  ~log_message_t()
  {
    if(fatal_) {

      // Create a backtrace.
      // This is probably only defined for platforms that have glibc.
#if defined __GNUG__
      void * array[100];
      size_t size;

      size = backtrace(array, 100);
      char ** symbols = backtrace_symbols(array, size);

      std::ostream & stream = cinchlog_t::instance().stream();
      for(size_t i(0); i<size; ++i) {
        stream << demangle(symbols[i]) << std::endl;
      } // for
#endif

      std::exit(1);
    } // if
  } // ~log_message_t

  ///
  // Return the output stream. Override this method to add additional
  // formatting to a particular severity output.
  ///
  virtual
  std::ostream &
  stream()
  {
    return cinchlog_t::instance().stream();
  } // stream

protected:

  const char * file_;
  int line_;

  bool fatal_;

}; // struct log_message_t

//----------------------------------------------------------------------------//
// Convenience macro to define severity levels.
//----------------------------------------------------------------------------//

#define severity_message_t(severity, format)                                   \
struct severity ## _log_message_t                                              \
  : public log_message_t                                                       \
{                                                                              \
  severity ## _log_message_t(const char * file, int line)                      \
    : log_message_t(file, line) {}                                             \
                                                                               \
  ~severity ## _log_message_t()                                                \
  {                                                                            \
    /* Clean colors from the stream */                                         \
    cinchlog_t::instance().stream() << COLOR_PLAIN;                            \
  }                                                                            \
                                                                               \
  std::ostream &                                                               \
  stream() override                                                            \
    format                                                                     \
};

//----------------------------------------------------------------------------//
// Define the insertion style severity levels.
//----------------------------------------------------------------------------//

severity_message_t(trace,
  {
#if CLOG_STRIP_LEVEL < 1
    std::ostream & stream = cinchlog_t::instance().stream();
    stream << OUTPUT_CYAN("[ TRACE ] ");
    return stream;
#else
    return cinchlog_t::instance().null_stream();
#endif
  });

severity_message_t(info,
  {
#if CLOG_STRIP_LEVEL < 2
    std::ostream & stream = cinchlog_t::instance().stream();
    stream << OUTPUT_GREEN("[  INFO ] ");
    return stream;
#else
    return cinchlog_t::instance().null_stream();
#endif
  });

severity_message_t(warn,
  {
#if CLOG_STRIP_LEVEL < 3
    std::ostream & stream = cinchlog_t::instance().stream();
    stream << OUTPUT_BROWN("[  WARN ] ") << COLOR_YELLOW;
    return stream;
#else
    return cinchlog_t::instance().null_stream();
#endif
  });

severity_message_t(error,
  {
#if CLOG_STRIP_LEVEL < 4
    std::ostream & stream = cinchlog_t::instance().stream();
    stream << OUTPUT_RED("[ ERROR ] ") << COLOR_RED;
    return stream;
#else
    return cinchlog_t::instance().null_stream();
#endif
  });

severity_message_t(fatal,
  {
#if CLOG_STRIP_LEVEL < 5
    std::ostream & stream = cinchlog_t::instance().stream();
    stream << OUTPUT_RED("[ FATAL ] ") << COLOR_LTRED;
    fatal_ = true;
    return stream;
#else
    return cinchlog_t::instance().null_stream();
#endif
  });

} // namespace cinch

//----------------------------------------------------------------------------//
// Macros
//----------------------------------------------------------------------------//

///
/// This handles all of the different logging modes for the insertion
/// style logging interface.
///
/// \param severity The severity level of the log entry.
///
#define clog(severity)                                                         \
  cinch::severity ## _log_message_t(__FILE__, __LINE__).stream()

///
/// Method style interface for trace level severity log entries.
///
#define clog_trace(message)                                                    \
  clog(info) << message << std::endl

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

///
/// Method style interface for fatal level severity log entries.
///
#define clog_fatal(message)                                                    \
  clog(fatal) << message << std::endl

#define clog_assert(test, message)                                             \
  !(test) && cinch_fatal(message)

#endif // cinch_cinchlog_h

/*~-------------------------------------------------------------------------~-*
 * Formatting options for vim.
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~-------------------------------------------------------------------------~-*/
