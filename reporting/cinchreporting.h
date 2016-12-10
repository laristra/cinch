/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2015 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#ifndef cinch_cinchreporting_h
#define cinch_cinchreporting_h

#include <iostream>
#include <sstream>
#include <string>

#include "colors.h"

///
// \file cinchreporting.h
// \authors bergen
// \date Initial file creation: Dec 10, 2016
///

namespace cinch {

///
// Strip upto last character C from character string.
//
// \tparam C The search character , e.g., C='/' will strip all
//           leading path information from a string.
//
// \param str The character string to modify.
///
template<
  char C
>
std::string
rstrip(
  const char * str
)
{
  std::string tmp(str);
  return tmp.substr(tmp.rfind(C)+1);
} // rstrip

///
// Implementation for information output.
//
// This function prints a colorized message. Colorization is disabled
// if HAVE_COLOR_OUTPUT is not defined.
//
// \param ss A std::stringstream containing the message to be printed to
//           standard output.
///
template<typename P>
void
info_impl(
  std::string message,
  P && predicate
)
{
  if(predicate()) {
    std::cout << OUTPUT_GREEN("Info ") << OUTPUT_LTGRAY(message) << std::endl;
  } // if
} // info_impl

///
// Implementation for warning output.
//
// This function prints a colorized warning. Colorization is disabled
// if HAVE_COLOR_OUTPUT is not defined.
//
// \tparam P The predicate function type.
//
// \param ss A std::stringstream containing the message to be printed to
//           standard output.
// \param file A character string containing the current file (__FILE__).
// \param line An integer string containing the current line (__LINE__).
// \param predicate A predicate function to control whether or not output
//                  is actually produced.
///
template<typename P>
void
warn_impl(
  std::string message,
  const char * file,
  int line,
  P && predicate
)
{
  if(predicate()) {
    std::stringstream output;

    // Start error output
    output << OUTPUT_YELLOW("!Warning!") <<
      std::endl;
    output << OUTPUT_YELLOW("\tMessage: ") <<
      OUTPUT_YELLOW(message) << std::endl;

    // File and line information
    output << OUTPUT_LTGRAY("\t[") <<
      OUTPUT_LTGRAY("line ") << OUTPUT_LTGRAY(line) << " " <<
      OUTPUT_LTGRAY(file) << OUTPUT_LTGRAY("] ") << std::endl;

    // Write the output to std::cerr
    std::cerr << output.str();
  } // if
} // warn_impl

///
// Implementation for error output.
//
// This function prints a colorized warning and call std::abort.
// Colorization is disabled if HAVE_COLOR_OUTPUT is not defined.
//
// \tparam P The predicate function type.
//
// \param ss A std::stringstream containing the message to be printed to
//           standard output.
// \param file A character string containing the current file (__FILE__).
// \param line An integer string containing the current line (__LINE__).
// \param predicate A predicate function to control whether or not output
//                  is actually produced.
///
template<typename P>
void
error_impl(
  std::string message,
  const char * file,
  int line,
  P && predicate
)
{
  if(predicate()) {
    std::stringstream output;

    // Start error output
    output << OUTPUT_RED("!!!RUNTIME ERROR: executing std::abort!!!") <<
      std::endl;
    output << OUTPUT_RED("\tMessage: ") <<
      OUTPUT_LTRED(message) << std::endl;

    // File and line information
    output << OUTPUT_RED("\t[") <<
      OUTPUT_LTGRAY("line ") << OUTPUT_LTGRAY(line) << " " <<
      OUTPUT_LTRED(file) << OUTPUT_RED("] ") << std::endl;

    // Write the output to std::cerr
    std::cerr << output.str();
  } // if

  // Abort!
  std::abort();
} // error_impl

template<bool B>
bool noop_bool() { return B; }

} // namespace cinch

#ifndef NDEBUG

/// Print an information message.
#define cinch_info(message)                                                    \
  std::stringstream ss;                                                        \
  ss << message;                                                               \
  cinch::info_impl(ss.str(), cinch::noop_bool<true>)

/// Print a warning message.
#define cinch_warn(message)                                                    \
  std::stringstream ss;                                                        \
  ss << message;                                                               \
  cinch::warn_impl(ss.str(), __FILE__, __LINE__, cinch::noop_bool<true>)

#else

// Turn off output for info and warn when debugging is disabled
#define cinch_info(message)
#define cinch_warn(message)

#endif // NDEBUG

/// Print an error message and abort.
#define cinch_error(message)                                                   \
  std::stringstream ss;                                                        \
  ss << message;                                                               \
  cinch::error_impl(ss.str(), __FILE__, __LINE__, cinch::noop_bool<true>)

/// Assert a test case and abort with an error message if the assertion fails.
#define cinch_assert(test, message)                                            \
  if(!(test)) {                                                                \
    cinch_error(message);                                                      \
  } // if

#endif // cinch_cinchreporting_h

/*~-------------------------------------------------------------------------~-*
 * Formatting options for vim.
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~-------------------------------------------------------------------------~-*/
