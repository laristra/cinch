/*----------------------------------------------------------------------------*
 * Copyright (c) 2016 Los Alamos National Security, LLC
 * All rights reserved.
 *----------------------------------------------------------------------------*/

#pragma once

/*! @file */

#if defined __GNUC__
  #include <cxxabi.h>
  #include <execinfo.h>
#endif // __GNUC__

#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <cstring>
#include <time.h>

#include <bitset>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <memory>

#if !defined(SERIAL) && defined(CLOG_ENABLE_MPI)
  #include <mpi.h>
#endif

#include <mutex>
#include <sstream>

// FIXME: guards?
#if !defined(_MSC_VER)
#include <sys/time.h>
#include <unistd.h>
#endif

#include <thread>
#include <unordered_map>
#include <utility>
#include <vector>

//----------------------------------------------------------------------------//
// Default value for tag bits.
//----------------------------------------------------------------------------//

#ifndef CLOG_TAG_BITS
#define CLOG_TAG_BITS 64
#endif

//----------------------------------------------------------------------------//
// Set the default strip level. All severity levels that are strictly
// less than the strip level will be stripped.
//
// TRACE 0
// INFO  1
// WARN  2
// ERROR 3
// FATAL 4
//----------------------------------------------------------------------------//

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
#define _clog_concat(a, b) a ## b

namespace cinch {

//----------------------------------------------------------------------------//
// Helper functions.
//----------------------------------------------------------------------------//

// The demangle and dumpstack functions are currently unused. I've left them
// here in case they are needed in the future.
#if 0
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
void
dumpstack()
{
#if defined __GNUC__
  void * array[100];
  size_t size;

  size = size_t(backtrace(array, 100));  // backtrace returns int
  char ** symbols = backtrace_symbols(array, int(size)); // func. takes int

  std::ostream & stream = std::cerr;

  std::cerr << OUTPUT_YELLOW("Dumping stack...") << std::endl;

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

  stream << std::flush;
#else
  std::cerr << "dumpstack: disabled because __GNUC__ is undefined" << std::endl;
#endif
} // dumpstack
#endif

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
// Auxiliary types.
//----------------------------------------------------------------------------//

#if !defined(SERIAL) && defined(CLOG_ENABLE_MPI)

// Options to configure buffered message packet behavior

#ifndef CLOG_MAX_MESSAGE_SIZE
#define CLOG_MAX_MESSAGE_SIZE 1024
#endif

#ifndef CLOG_MAX_PACKET_BUFFER
#define CLOG_MAX_PACKET_BUFFER 1024
#endif

#ifndef CLOG_PACKET_FLUSH_INTERVAL
#define CLOG_PACKET_FLUSH_INTERVAL 100
#endif

//----------------------------------------------------------------------------//
// Packet type.
//----------------------------------------------------------------------------//

struct packet_t
{
  static constexpr size_t sec_bytes = sizeof(time_t);
  static constexpr size_t usec_bytes = sizeof(suseconds_t);

  packet_t(const char * msg = nullptr) {
    timeval stamp;
    if(gettimeofday(&stamp, NULL)) {
      std::cerr << "CLOG: call to gettimeofday failed!!! " <<
        __FILE__ << __LINE__ << std::endl;
      std::exit(1);
    } // if

    strncpy(data_, reinterpret_cast<const char *>(&stamp.tv_sec), sec_bytes);
    strncpy(data_+sec_bytes, reinterpret_cast<const char *>(&stamp.tv_usec),
      usec_bytes);

    std::ostringstream oss;
    oss << msg;

    strcpy(data_+sec_bytes+usec_bytes, oss.str().c_str());
  } // packet_t

  time_t const & seconds() const {
    return *reinterpret_cast<time_t const *>(data_);
  } // seconds

  suseconds_t const & useconds() const {
    return *reinterpret_cast<suseconds_t const *>(data_+sec_bytes);
  } // seconds

  const char * message() {
    return data_ + sec_bytes + usec_bytes;
  } // message

  const char * data() const {
    return data_;
  } // data

  size_t bytes() const {
    return sec_bytes + usec_bytes + CLOG_MAX_MESSAGE_SIZE;
  } // bytes

  bool operator < (packet_t const & b) {
    return this->seconds() == b.seconds() ?
      this->useconds() < b.useconds() :
      this->seconds() < b.seconds();
  } // operator <

private:

  char data_[sec_bytes + usec_bytes + CLOG_MAX_MESSAGE_SIZE];

}; // packet_t

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

// Forward
inline void flush_packets();

struct mpi_state_t
{
  static mpi_state_t & instance() {
    static mpi_state_t s;
    return s;
  } // instance

  void init() {
    MPI_Comm_rank(MPI_COMM_WORLD, &rank_);
    MPI_Comm_size(MPI_COMM_WORLD, &size_);

    std::thread flusher(flush_packets);
    instance().flusher_thread().swap(flusher);

    initialized_ = true;
  } // init

  bool initialized() { return initialized_; }

  int rank() { return rank_; }
  int size() { return size_; }

  std::thread & flusher_thread() { return flusher_thread_; }
  std::mutex & packets_mutex() { return packets_mutex_; }
  std::vector<packet_t> & packets() { return packets_; }

  bool run_flusher() { return run_flusher_; }
  void end_flusher() { run_flusher_ = false; }

private:

  ~mpi_state_t()
  {
    if(initialized_) {
      end_flusher();
      flusher_thread_.join();
    } // if
  }

  int rank_;
  int size_;
  std::thread flusher_thread_;
  std::mutex packets_mutex_;
  std::vector<packet_t> packets_;
  bool run_flusher_ = true;
  bool initialized_ = false;

}; // mpi_state_t

#endif // !defined(SERIAL) && defined(CLOG_ENABLE_MPI)

///
/// Stream buffer type to allow output to multiple targets
/// a la the tee function.
///

//----------------------------------------------------------------------------//
//! The tee_buffer_t type provides a stream buffer that allows output to
//! multiple targets.
//!
//! @ingroup clog
//----------------------------------------------------------------------------//

class tee_buffer_t
  : public std::streambuf
{
public:

  //--------------------------------------------------------------------------//
  //! The buffer_data_t type is used to hold state and the actual low-level
  //! stream buffer pointer.
  //--------------------------------------------------------------------------//

  struct buffer_data_t {
    bool enabled;
    bool colorized;
    std::streambuf * buffer;
  }; // struct buffer_data_t

  //--------------------------------------------------------------------------//
  //! Add a buffer to which output should be written. This also enables
  //! the buffer,i.e., output will be written to it.
  //--------------------------------------------------------------------------//

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

  //--------------------------------------------------------------------------//
  //! Enable a buffer so that output is written to it. This is mainly
  //! for buffers that have been disabled and need to be re-enabled.
  //--------------------------------------------------------------------------//

  bool
  enable_buffer(
    std::string key
  )
  {
    buffers_[key].enabled = true;
    return buffers_[key].enabled;
  } // enable_buffer

  //--------------------------------------------------------------------------//
  //! Disable a buffer so that output is not written to it.
  //--------------------------------------------------------------------------//

  bool
  disable_buffer(
    std::string key
  )
  {
    buffers_[key].enabled = false;
    return buffers_[key].enabled;
  } // disable_buffer

protected:

  //--------------------------------------------------------------------------//
  //! Override the overflow method. This streambuf has no buffer, so overflow
  //! happens for every character that is written to the string, allowing
  //! us to write to multiple output streams. This method also detects
  //! colorization strings embedded in the character stream and removes
  //! them from output that is going to non-colorized buffers.
  //!
  //! \param c The character to write. This is passed in as an int so that
  //!          non-characters like EOF can be written to the stream.
  //--------------------------------------------------------------------------//

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
      test_buffer_.append(1, char(c));  // takes char

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
            // This is a plain color termination. Write the
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

  //--------------------------------------------------------------------------//
  //! Override the sync method so that we sync all of the output buffers.
  //--------------------------------------------------------------------------//

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

//----------------------------------------------------------------------------//
//! The tee_stream_t type provides a stream class that writes to multiple
//! output buffers.
//----------------------------------------------------------------------------//

struct tee_stream_t
  : public std::ostream
{

  tee_stream_t()
  :
    std::ostream(&tee_)
  {
    // Allow users to turn std::clog output on and off from
    // their environment.
    if(std::getenv("CLOG_ENABLE_STDLOG")) {
      tee_.add_buffer("clog", std::clog.rdbuf(), true);
    } // if
  } // tee_stream_t

  tee_stream_t &
  operator * ()
  {
    return *this;
  } // operator *

  //--------------------------------------------------------------------------//
  //! Add a new buffer to the output.
  //--------------------------------------------------------------------------//

  void
  add_buffer(
    std::string key,
    std::ostream & s,
    bool colorized = false
  )
  {
    tee_.add_buffer(key, s.rdbuf(), colorized);
  } // add_buffer

  //--------------------------------------------------------------------------//
  //! Enable an existing buffer.
  //!
  //! \param key The string identifier of the streambuf.
  //--------------------------------------------------------------------------//

  bool
  enable_buffer(
    std::string key
  )
  {
    tee_.enable_buffer(key);
    return true;
  } // enable_buffer

  //--------------------------------------------------------------------------//
  //! Disable an existing buffer.
  //!
  //! \param key The string identifier of the streambuf.
  //--------------------------------------------------------------------------//

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

//----------------------------------------------------------------------------//
//! The clog_t type provides access to logging parameters and configuration.
//!
//! This type provides access to the underlying logging parameters for
//! configuration and information. The cinch logging functions provide
//! basic logging with an interface that is similar to Google's GLOG
//! and the Boost logging utilities.
//!
//! @note We may want to consider adopting one of these packages
//! in the future.
//!
//! @ingroup clog
//----------------------------------------------------------------------------//

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
  init(std::string active = "none")
  {
    #if defined(CLOG_DEBUG)
      std::cerr << COLOR_LTGRAY << "CLOG: initializing runtime" <<
        COLOR_PLAIN << std::endl;
    #endif

    // Because active tags are specified at runtime, it is
    // necessary to maintain a map of the compile-time registered
    // tag names to the id that they get assigned after the clog_t
    // initialization (register_tag). This map will be used to populate
    // the tag_bitset_ for fast runtime comparisons of enabled tag groups.

    // Note: For the time being, the map uses actual strings rather than
    // hashes. We should consider creating a const_string_t type for
    // constexpr string creation.

    // Initialize everything to false. This is the default, i.e., "none".
    tag_bitset_.reset();

    // The default group is always active (unscoped). To avoid
    // output for this tag, make sure to scope all CLOG output.
    tag_bitset_.set(0);

    if(active == "all") {
      // Turn on all of the bits for "all".
      tag_bitset_.set();
    }
    else if(active != "none") {
      // Turn on the bits for the selected groups.
      std::istringstream is(active);
      std::string tag;
      while(std::getline(is, tag, ',')) {
        if(tag_map_.find(tag) != tag_map_.end()) {
          tag_bitset_.set(tag_map_[tag]);
        }
        else {
          std::cerr << "CLOG WARNING: " << tag <<
            " has not been registered. Ignoring this group..." << std::endl;
        } // if
      } // while
    } // if

    #if defined(CLOG_DEBUG)
      std::cerr << COLOR_LTGRAY << "CLOG: active tags (" <<
        active << ")" << COLOR_PLAIN << std::endl;
    #endif


#if !defined(SERIAL) && defined(CLOG_ENABLE_MPI)

    #if defined(CLOG_DEBUG)
      std::cerr << COLOR_LTGRAY << "CLOG: initializing mpi state" <<
        COLOR_PLAIN << std::endl;
    #endif

    mpi_state_t::instance().init();
#endif

    initialized_ = true;
  } // init

  ///
  /// Return the tag map.
  ///
  const std::unordered_map<std::string, size_t> &
  tag_map()
  {
    return tag_map_;
  } // tag_map

  ///
  /// Return the buffered log stream.
  ///
  std::stringstream &
  buffer_stream()
  {
    return buffer_stream_;
  } // stream

  ///
  /// Return the log stream.
  ///
  std::ostream &
  stream()
  {
    return *stream_;
  } // stream

  ///
  /// Return the log stream predicated on a boolean.
  /// This method interface will allow us to select between
  /// the actual stream and a null stream.
  ///
  std::ostream &
  severity_stream(bool active = true)
  {
    return active ? buffer_stream_ : null_stream_;
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
  register_tag(const char * tag)
  {
    // If the tag is already registered, just return the previously
    // assigned id. This allows tags to be registered in headers.
    if(tag_map_.find(tag) != tag_map_.end()) {
      return tag_map_[tag];
    } // if

    const size_t id = ++tag_id_;
    assert(id < CLOG_TAG_BITS && "Tag bits overflow! Increase CLOG_TAG_BITS");
#if defined(CLOG_DEBUG)
    std::cerr << COLOR_LTGRAY << "CLOG: registering tag " << tag <<
      ": " << id << COLOR_PLAIN << std::endl;
#endif
    tag_map_[tag] = id;
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

#if defined(CLOG_DEBUG)
    auto active_set = tag_bitset_.test(active_tag_) == 1 ? "true" : "false";
    std::cerr << COLOR_LTGRAY << "CLOG: tag " << active_tag_ << " is " <<
      active_set << COLOR_PLAIN << std::endl;
#endif

    // If the runtime context hasn't been initialized, return true only
    // if the user has enabled externally-scoped messages.
    if(!initialized_) {
#if defined(CLOG_ENABLE_EXTERNAL)
      return true;
#else
      return false;
#endif
    } // if

    return tag_bitset_.test(active_tag_);
#else
    return true;
#endif // CLOG_ENABLE_TAGS
  } // tag_enabled

  size_t
  lookup_tag(const char * tag)
  {
    if(tag_map_.find(tag) == tag_map_.end()) {
      std::cerr << COLOR_YELLOW << "CLOG: !!!WARNING " << tag <<
        " has not been registered. Ignoring this group..." <<
        COLOR_PLAIN << std::endl;
      return 0;
    } // if

    return tag_map_[tag];
  } // lookup_tag

  bool
  initialized()
  {
    return initialized_;
  } // initialized

#if !defined(SERIAL) && defined(CLOG_ENABLE_MPI)
  int
  rank()
  {
    return mpi_state_t::instance().rank();
  } // rank

  int
  size()
  {
    return mpi_state_t::instance().size();
  } // rank
#endif

private:

  ///
  /// Constructor. This method is hidden because we are a singleton.
  ///
  clog_t()
  :
    null_stream_(0), tag_id_(0), active_tag_(0)
  {
  } // clog_t

  ~clog_t()
  {
#if defined(CLOG_DEBUG)
    std::cerr << COLOR_LTGRAY << "CLOG: clog_t destructor" << std::endl;
#endif
  }

  bool initialized_ = false;

  tee_stream_t stream_;
  std::stringstream buffer_stream_;
  std::ostream null_stream_;

  size_t tag_id_;
  size_t active_tag_;
  std::bitset<CLOG_TAG_BITS> tag_bitset_;
  std::unordered_map<std::string, size_t> tag_map_;

}; // class clog_t

#if !defined(SERIAL) && defined(CLOG_ENABLE_MPI)
void flush_packets() {
  while(mpi_state_t::instance().run_flusher()) {
    usleep(CLOG_PACKET_FLUSH_INTERVAL);

    {
    std::lock_guard<std::mutex> guard(mpi_state_t::instance().packets_mutex());

    if(mpi_state_t::instance().packets().size()) {
      std::sort(mpi_state_t::instance().packets().begin(),
        mpi_state_t::instance().packets().end());

      for(auto & p: mpi_state_t::instance().packets()) {
        clog_t::instance().stream() << p.message();
      } // for

      mpi_state_t::instance().packets().clear();
    } // if
    } // scope

  } // while
} // flush_packets
#endif

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
#if defined(CLOG_DEBUG)
    std::cerr << COLOR_LTGRAY << "CLOG: activating tag " << tag <<
      COLOR_PLAIN << std::endl;
#endif

    // Warn users about externally-scoped messages
    if(!clog_t::instance().initialized()) {
      std::cerr << COLOR_YELLOW << "CLOG: !!!WARNING You cannot use " <<
        "tag guards for externally scoped messages!!! " <<
        "This message will be active if CLOG_ENABLE_EXTERNAL is defined!!!" <<
        COLOR_PLAIN << std::endl;
    } // if

    clog_t::instance().active_tag() = tag;
  } // clog_tag_scope_t

  ~clog_tag_scope_t()
  {
    clog_t::instance().active_tag() = stash_;
  } // ~clog_tag_scope_t

private:

  size_t stash_;

}; // clog_tag_scope_t

#if defined(ENABLE_CLOG)

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
  cinch::clog_t::instance().register_tag(_clog_stringify(name))

// Lookup the tag id
#define clog_tag_lookup(name)                                                  \
  cinch::clog_t::instance().lookup_tag(_clog_stringify(name))

// Create a new tag scope.
#define clog_tag_guard(name)                                                   \
  cinch::clog_tag_scope_t name ## _clog_tag_scope__(clog_tag_lookup(name))

#else

#define clog_register_tag(name)
#define clog_tag_lookup(name)
#define clog_tag_guard(name)

#endif // ENABLE_CLOG

#define clog_tag_map()                                                         \
  cinch::clog_t::instance().tag_map()

#define send_to_one(message)                                                   \
                                                                               \
  if(mpi_state_t::instance().initialized()) { \
    packet_t pkt(message);                                                     \
                                                                               \
    packet_t * pkts = mpi_state_t::instance().rank() == 0 ?                    \
      new packet_t[mpi_state_t::instance().size()] :                           \
      nullptr;                                                                 \
                                                                               \
    MPI_Gather(pkt.data(), pkt.bytes(), MPI_BYTE,                              \
      pkts, pkt.bytes(), MPI_BYTE, 0, MPI_COMM_WORLD);                         \
                                                                               \
    if(mpi_state_t::instance().rank()==0) {                                    \
                                                                               \
      std::lock_guard<std::mutex>                                              \
        guard(mpi_state_t::instance().packets_mutex());                        \
                                                                               \
      for(size_t i{0}; i<mpi_state_t::instance().size(); ++i) {                \
        mpi_state_t::instance().packets().push_back(pkts[i]);                  \
      } /* for */                                                              \
                                                                               \
      delete[] pkts;                                                           \
                                                                               \
    } /* if */                                                                 \
  } /* if */

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

/*!
  The log_message_t type provides a base class for implementing
  formatted logging utilities.
 */
template<typename P>
struct log_message_t
{
  /*!
    Constructor.

    @tparam P Predicate function type.

    @param file            The current file (where the log message was
                           created).  In general, this will always use the
                           __FILE__ parameter from the calling macro.
    @param line            The current line (where the log message was called).
                           In general, this will always use the __LINE__
                           parameter from the calling macro.
    @param predicate       The predicate function to determine whether or not
                           the calling runtime should produce output.
    @param can_send_to_one A boolean indicating whether the calling scope
                           can route messages through one rank.
   */
  log_message_t(
    const char * file,
    int line,
    P && predicate,
    bool can_send_to_one = true
  )
  :
    file_(file), line_(line), predicate_(predicate),
    can_send_to_one_(can_send_to_one), clean_color_(false)
  {
#if defined(CLOG_DEBUG)
    std::cerr << COLOR_LTGRAY << "CLOG: log_message_t constructor " <<
      file << " " << line << COLOR_PLAIN << std::endl;
#endif
  } // log_message_t

  virtual
  ~log_message_t()
  {
#if defined(CLOG_DEBUG)
    std::cerr << COLOR_LTGRAY << "CLOG: log_message_t destructor " <<
      COLOR_PLAIN << std::endl;
#endif

#if !defined(SERIAL) && defined(CLOG_ENABLE_MPI)
    if(can_send_to_one_) {
      send_to_one(clog_t::instance().buffer_stream().str().c_str());
    }
    else {
      clog_t::instance().stream() << clog_t::instance().buffer_stream().str();
    } // if
#else
    clog_t::instance().stream() << clog_t::instance().buffer_stream().str();
#endif

    clog_t::instance().buffer_stream().str(std::string{});
  } // ~log_message_t

  ///
  /// Return the output stream. Override this method to add additional
  // formatting to a particular severity output.
  ///
  virtual
  std::ostream &
  stream()
  {
    return clog_t::instance().severity_stream(predicate_());
  } // stream

protected:

  const char * file_;
  int line_;
  P & predicate_;
  bool can_send_to_one_;
  bool clean_color_;

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
    P && predicate = true_state,                                               \
    bool can_send_to_one = true                                                \
  )                                                                            \
    : log_message_t<P>(file, line, predicate, can_send_to_one) {}              \
                                                                               \
  ~severity ## _log_message_t()                                                \
  {                                                                            \
    /* Clean colors from the stream */                                         \
    if(clean_color_) {                                                         \
      clog_t::instance().buffer_stream() << COLOR_PLAIN;                       \
    }                                                                          \
  }                                                                            \
                                                                               \
  std::ostream &                                                               \
  stream() override                                                            \
    /* This is replaced by the scoped logic */                                 \
    format                                                                     \
}

//----------------------------------------------------------------------------//
// Define the insertion style severity levels.
//----------------------------------------------------------------------------//

#define message_stamp                                                          \
  timestamp() << " " << cinch::rstrip<'/'>(file_) << ":" << line_

#if !defined(SERIAL) && defined(CLOG_ENABLE_MPI)
#define mpi_stamp \
  " r" << mpi_state_t::instance().rank()
#else
#define mpi_stamp ""
#endif

// Trace
severity_message_t(trace, decltype(cinch::true_state),
  {
    std::ostream & stream =
      clog_t::instance().severity_stream(CLOG_STRIP_LEVEL < 1 &&
        predicate_() && clog_t::instance().tag_enabled());

    {
    stream << OUTPUT_CYAN("[T") << OUTPUT_LTGRAY(message_stamp);
    stream << OUTPUT_DKGRAY(mpi_stamp);
    stream << OUTPUT_CYAN("] ");
    } // scope

    return stream;
  });

// Info
severity_message_t(info, decltype(cinch::true_state),
  {
    std::ostream & stream =
      clog_t::instance().severity_stream(CLOG_STRIP_LEVEL < 2 &&
        predicate_() && clog_t::instance().tag_enabled());

    {
    stream << OUTPUT_GREEN("[I") << OUTPUT_LTGRAY(message_stamp);
    stream << OUTPUT_DKGRAY(mpi_stamp);
    stream << OUTPUT_GREEN("] ");
    } // scope

    return stream;
  });

// Warn
severity_message_t(warn, decltype(cinch::true_state),
  {
    std::ostream & stream =
      clog_t::instance().severity_stream(CLOG_STRIP_LEVEL < 3 &&
        predicate_() && clog_t::instance().tag_enabled());

    {
    stream << OUTPUT_BROWN("[W") << OUTPUT_LTGRAY(message_stamp);
    stream << OUTPUT_DKGRAY(mpi_stamp);
    stream << OUTPUT_BROWN("] ") << COLOR_YELLOW;
    } // scope

    clean_color_ = true;
    return stream;
  });

// Error
severity_message_t(error, decltype(cinch::true_state),
  {
    std::ostream & stream = std::cerr;

    {
    stream << OUTPUT_RED("[E") << OUTPUT_LTGRAY(message_stamp);
    stream << OUTPUT_DKGRAY(mpi_stamp);
    stream << OUTPUT_RED("] ") << COLOR_LTRED;
    } // scope

    clean_color_ = true;
    return stream;
  });

} // namespace cinch

//----------------------------------------------------------------------------//
// Private macro interface
//----------------------------------------------------------------------------//

//
// Indirection to expand counter name.
//

#define clog_counter_varname(str, line)                                        \
  _clog_concat(str, line)

//
// Indirection to expand counter name.
//

#define clog_counter(str)                                                      \
  clog_counter_varname(str, __LINE__)

//
// Define a counter name.
//

#define counter_name clog_counter(counter)

//----------------------------------------------------------------------------//
// Macro Interface
//----------------------------------------------------------------------------//

#if defined(ENABLE_CLOG)

/*!
  @def clog_init(active)

  This call initializes the clog runtime with the list of tags specified
  in \em active.

  @param active A const char * or std::string containing the list of
                active tags. Tags should be comma delimited.

  \b Usage
  \code
  int main(int argc, char ** argv) {

     // Fill a string object with the active tags.
     std::string tags{"init,advance,analysis"};

     // Initialize the clog runtime with active tags, 'init', 'advance',
     // and 'analysis'.
     clog_init(tags);

     return 0;
  } // main
  \endcode

  @ingroup clog
 */

#define clog_init(active)                                                      \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  cinch::clog_t::instance().init(active)

/*!
  @def clog(severity)

  This handles all of the different logging modes for the insertion
  style logging interface.

  @param severity The severity level of the log entry.

  @note The form "true && ..." is necessary for tertiary argument
        evaluation so that the std::ostream & returned by the stream()
        function can be implicitly converted to an int.

  @b Usage
  @code
  int value{20};

  // Print the value at info severity level
  clog(info) << "Value: " << value << std::endl;

  // Print the value at warn severity level
  clog(warn) << "Value: " << value << std::endl;
  @endcode

  @ingroup clog
 */

#define clog(severity)                                                         \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  true && cinch::severity ## _log_message_t(__FILE__, __LINE__).stream()

/*!
  @def clog_trace(message)

  Method style interface for trace level severity log entries.

  @param message The stream message to be printed.

  @b Usage
  @code
  int value{20};

  // Print the value at trace severity level
  clog_trace("Value: " << value);
  @endcode

  @ingroup clog
 */

#define clog_trace(message)                                                    \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  cinch::trace_log_message_t(__FILE__, __LINE__).stream() << message

/*!
  @def clog_info(message)

  Method style interface for info level severity log entries.

  @param message The stream message to be printed.

  @b Usage
  @code
  int value{20};

  // Print the value at info severity level
  clog_info("Value: " << value);
  @endcode

  @ingroup clog
 */

#define clog_info(message)                                                     \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  cinch::info_log_message_t(__FILE__, __LINE__).stream() << message

/*!
  @def clog_warn(message)

  Method style interface for warn level severity log entries.

  @param message The stream message to be printed.

  @b Usage
  @code
  int value{20};

  // Print the value at warn severity level
  clog_warn("Value: " << value);
  @endcode

  @ingroup clog
 */

#define clog_warn(message)                                                     \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  cinch::warn_log_message_t(__FILE__, __LINE__).stream() << message

/*!
  @def clog_error(message)

  Method style interface for error level severity log entries.

  @param message The stream message to be printed.

  @b Usage
  @code
  int value{20};

  // Print the value at error severity level
  clog_error("Value: " << value);
  @endcode

  @ingroup clog
 */

#define clog_error(message)                                                    \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  cinch::error_log_message_t(__FILE__, __LINE__).stream() << message

#else

//
// These are empty defintions for the case where ENABLE_CLOG is not defined.
//

#define clog_init(active)
#define clog(severity) if(true) {} else std::cerr
#define clog_trace(message)
#define clog_info(message)
#define clog_warn(message)
#define clog_error(message)

/*!
  @def clog_every_n(severity, n, message)

  Method style interface to output every nth iteration. An iteration is
  defined as an instance that the clog runtime sees the output line.

  @param severity The severity level at which to output the message.
  @param n        The iteration frequency at which to output the message.
  @param message  The stream message to be printed.

  @b Usage
  @code
  for(size_t i{0}; i<10; ++i) {
     // This will output every other time
     clog_every_n(info, 2, "Iterate: " << i);
  } // for
  @endcode

  @ingroup clog
 */

#define clog_every_n(severity, n, message)                                     \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  static size_t counter_name = 0;                                              \
  if(counter_name++%n == 0) { clog_ ## severity(message); }

#endif // ENABLE_CLOG

/*!
  @def clog_fatal(message)

  Throw a runtime exception with the provided message.

  @param message The stream message to be printed.

  @note Fatal level severity log entires are not disabled by tags or
        by the ENABLE_CLOG or CLOG_STRIP_LEVEL build options, i.e.,
        they are always active.

  @b Usage
  @code
  int value{20};

  // Print the value and exit
  clog_fatal("Value: " << value);
  @endcode

  @ingroup clog
 */

#define clog_fatal(message)                                                    \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  {                                                                            \
  std::stringstream _sstream;                                                  \
  _sstream << OUTPUT_LTRED("FATAL ERROR ") <<                                  \
    OUTPUT_YELLOW(cinch::rstrip<'/'>(__FILE__) << ":" << __LINE__ << " ") <<   \
    OUTPUT_LTRED(message) << std::endl;                                        \
  throw std::runtime_error(_sstream.str());                                    \
  } /* scope */

/*!
  @def clog_assert(test, message)

  Clog assertion interface. Assertions allow the developer to catch
  invalid program state. This call will invoke clog_fatal if the test
  condition is false.

  @param test    The test condition.
  @param message The stream message to be printed.

  @note Failed assertions are not disabled by tags or
        by the ENABLE_CLOG or CLOG_STRIP_LEVEL build options, i.e.,
        they are always active.

  @b Usage
  @code
  int value{20};

  // Print the value and exit
  clog_assert(value == 20, "invalid value");
  @endcode

  @ingroup clog
 */

#define clog_assert(test, message)                                             \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  if(!(test)) { clog_fatal(message); }
//  !(test) && clog_fatal(message)

/*!
  @def clog_add_buffer(name, ostream, colorized)

  Add a named stream buffer to the clog runtime. Added buffers are enabled
  by default, and can be disabled by calling \ref clog_disable_buffer.

  @param name      The name of the output buffer.
  @param ostream   The output stream of type std::ostream.
  @param colorized A boolean indicating whether or not the output to
                   this stream should be colorized.

  @ingroup clog
 */

#define clog_add_buffer(name, ostream, colorized)                              \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  cinch::clog_t::instance().config_stream().add_buffer(name, ostream,          \
    colorized)

/*!
  @def clog_enable_buffer(name)

  Enable an output buffer.

  @param name The name of the output stream that was used to add the buffer.

  @ingroup clog
 */

#define clog_enable_buffer(name)                                               \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  cinch::clog_t::instance().config_stream().enable_buffer(name)

/*!
  @def clog_disable_buffer(name)

  Disable an output buffer.

  @param name The name of the output stream that was used to add the buffer.

  @ingroup clog
 */

#define clog_disable_buffer(name)                                              \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  cinch::clog_t::instance().config_stream().disable_buffer(name)

namespace clog {

  /*!
    Enum type to specify output delimiters for containers.

    @ingroup clog
   */

  enum clog_delimiters_t : size_t {
    newline,
    space,
    colon,
    semicolon,
    comma
  }; // enum clog_delimiters_t

} // namespace

// \TODO actually fix warning
#if defined(__clang__)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wtautological-compare"
#endif

/*!
  @def clog_container(severity, banner, container, delimiter)

  Output the contents of a standard container type. Valid container types
  must implement a forward iterator.

  @param severity  The severity level at which to output the message.
  @param banner    A top-level label for the container output.
  @param container The container to output.
  @param delimiter The output character to use to delimit container
                   entries, e.g., newline, comma, space, etc. Valid
                   delimiters are defined in clog_delimiters_t.

  @ingroup clog
 */

#define clog_container(severity, banner, container, delimiter)                 \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
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

#if defined(__clang__)
#pragma clang diagnostic pop
#endif

// Enable MPI
#if !defined(SERIAL) && defined(CLOG_ENABLE_MPI)

namespace cinch {

/*!
  The mpi_config_t type provides an interface to MPI runtime state
  information.

  @ingroup clog
 */

struct mpi_config_t {

  /*!
    Meyer's singleton instance.

    @return The single instance of this type.
   */

  static
  mpi_config_t &
  instance()
  {
    static mpi_config_t m;
    return m;
  } // instance

  /*!
    Return the active rank as a constant reference.
   */

  const
  size_t &
  active_rank() const
  {
    return active_rank_;
  } // active_rank

  /*!
    Return the active rank as a mutable reference.
   */

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

/*!
  Return a boolean indicating whether the current runtime rank matches a
  statically defined value.

  @tparam RANK The static rank to use in the comparison.

  @ingroup clog
 */

template<
  size_t RANK
>
inline
bool
is_static_rank()
{
  int part;
  MPI_Comm_rank(MPI_COMM_WORLD, &part);
  return part == RANK;
} // is_static_rank

/*!
  Return a boolean that indicates whether the current runtime rank is active.

  @ingroup clog
 */

inline
bool
is_active_rank()
{
  int part;
  MPI_Comm_rank(MPI_COMM_WORLD, &part);
  return part == mpi_config_t::instance().active_rank();
} // is_active_rank

} // namespace

/*!
  @def clog_rank(severity, rank)

  This handles all of the different logging modes for the insertion
  style logging interface.

  @param severity The severity level of the log entry.
  @param rank     The rank for which to output the message stream.

  @note The form "true && ..." is necessary for tertiary argument
        evaluation so that the std::ostream & returned by the stream()
        function can be implicitly converted to an int.

  @b Usage
  @code
  int value{20};

  // Print the value at info severity level on rank 0
  clog_rank(info, 0) << "Value: " << value << std::endl;

  // Print the value at warn severity level on rank 1
  clog_rank(warn, 1) << "Value: " << value << std::endl;
  @endcode

  @ingroup clog
 */

#define clog_rank(severity, rank)                                              \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  true && cinch::severity ## _log_message_t(__FILE__, __LINE__,                \
    cinch::is_static_rank<rank>, false).stream()

/*!
  @def clog_set_output_rank(rank)

  Set the output rank for calls to clog_one.

  @param rank The rank for which output will be generated.

  @ingroup clog
 */

#define clog_set_output_rank(rank)                                             \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  cinch::mpi_config_t::instance().active_rank() = rank

/*!
  @def clog_one(severity)

  This handles all of the different logging modes for the insertion
  style logging interface. This will only output on the rank specified
  by clog_set_output_rank.

  @param severity The severity level of the log entry.

  @ingroup clog
 */

#define clog_one(severity)                                                     \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
  true && cinch::severity ## _log_message_t(__FILE__, __LINE__,                \
    cinch::is_active_rank, false).stream()

/*!
  @def clog_container_rank(severity, banner, container, delimiter, rank)

  Output the contents of a standard container type on the specified
  rank. Valid container types must implement a forward iterator.

  @param severity  The severity level at which to output the message.
  @param banner    A top-level label for the container output.
  @param container The container to output.
  @param delimiter The output character to use to delimit container
                   entries, e.g., newline, comma, space, etc. Valid
                   delimiters are defined in clog_delimiters_t.
  @param rank      The rank for which to output the message stream.

  @ingroup clog
 */

#define clog_container_rank(severity, banner, container, delimiter, rank)      \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
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
      entry++ << OUTPUT_CYAN("]") << std::endl;                                \
    ss << *c;                                                                  \
    (c != --container.end()) && ss << delim;                                   \
  }                                                                            \
  clog_rank(severity, rank) << ss.str() << std::endl;                          \
  } /* scope */

/*!
  @def clog_container_one(severity, banner, container, delimiter)

  Output the contents of a standard container type on the rank
  specified by clog_set_output_rank. Valid container types must
  implement a forward iterator.

  @param severity  The severity level at which to output the message.
  @param banner    A top-level label for the container output.
  @param container The container to output.
  @param delimiter The output character to use to delimit container
                   entries, e.g., newline, comma, space, etc. Valid
                   delimiters are defined in clog_delimiters_t.
  
  @ingroup clog
 */

#define clog_container_one(severity, banner, container, delimiter)             \
/* MACRO IMPLEMENTATION */                                                     \
                                                                               \
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
      entry++ << OUTPUT_CYAN("]") << std::endl;                                \
    ss << *c;                                                                  \
    (c != --container.end()) && ss << delim;                                   \
  }                                                                            \
  clog_one(severity) << ss.str() << std::endl;                                 \
  } /* scope */

#else

#define clog_rank(severity, rank) if(true) {} else std::cerr
#define clog_set_output_rank(rank)
#define clog_one(severity) if(true) {} else std::cerr
#define clog_container_rank(severity, banner, container, delimiter, rank) if(true) {} else std::cerr

#if defined(__clang__)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
#endif

#define clog_container_one(severity, banner, container, delimiter) if(true) {} else std::cerr

#if defined(__clang__)
#pragma clang diagnostic pop
#endif

#endif // !SERIAL && CLOG_ENABLE_MPI
