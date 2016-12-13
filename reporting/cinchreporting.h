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
inline
std::string
rstrip(
  const char * str
)
{
  std::string tmp(str);
  return tmp.substr(tmp.rfind(C)+1);
} // rstrip

///
// No-op function to return a boolean value.
//
// \tparam B The boolean value to return, i.e., true or false.
///
template<
  bool B,
  typename C = size_t
>
inline
bool
noop_bool(C c = 0)
{
  return B;
} // noop_bool

///
// Wrapper to execute std::abort as a boolean function.
///
inline
bool
abort_bool()
{
  std::abort();
  return true;
} // abort_bool

} // namespace cinch

//----------------------------------------------------------------------------//
// Macro definitions.
//----------------------------------------------------------------------------//

/// Print an information message if the predicate evaluates to true.
#define cinch_info_impl(message, predicate)                                    \
  predicate() &&                                                               \
    std::cout << OUTPUT_GREEN("Info ") << OUTPUT_LTGRAY(message) << std::endl

/// Print the contents of a container, using the user-provided predicate
/// function to determine which elements should be otuput.
#define cinch_container_info_impl(banner, container, delimiter, predicate)     \
  std::cout << OUTPUT_GREEN("Info ") << OUTPUT_LTGRAY(banner) << std::endl;    \
  for(auto c: container) {                                                     \
    predicate(c) && std::cout << OUTPUT_LTGRAY(c) << delimiter;                \
  }                                                                            \
  std::cout << std::endl;

/// Print a warning message if the predicate evaluates to true.
#define cinch_warn_impl(message, predicate)                                    \
  predicate() &&                                                               \
    std::cout << OUTPUT_BROWN("!Warning!") << std::endl <<                     \
    OUTPUT_BROWN("  Message: ") << OUTPUT_YELLOW(message) << std::endl <<      \
    OUTPUT_LTGRAY("  [") <<                                                    \
      OUTPUT_LTGRAY("line ") << OUTPUT_LTGRAY(__LINE__) << " " <<              \
      OUTPUT_LTGRAY(__FILE__) <<                                               \
    OUTPUT_LTGRAY("] ") << std::endl

/// Print an error message if the predicate evaluates to true and abort.
/// Regardless of the predicate, std::abort() is executed.
#define cinch_error_impl(message, predicate)                                   \
  predicate() &&                                                               \
    std::cout << OUTPUT_RED("!!!ERROR!!!") << std::endl <<                     \
    OUTPUT_RED("  Message: ") << OUTPUT_LTRED(message) << std::endl <<         \
    OUTPUT_RED("  [") <<                                                       \
      OUTPUT_LTGRAY("line ") << OUTPUT_LTGRAY(__LINE__) << " " <<              \
      OUTPUT_LTGRAY(__FILE__) <<                                               \
    OUTPUT_RED("] ") << std::endl <<                                           \
    OUTPUT_RED("Executing std::abort()...") << std::endl &&                    \
    cinch::abort_bool()

#ifndef NDEBUG

/// Print an information message.
#define cinch_info(message)                                                    \
  cinch_info_impl(message, cinch::noop_bool<true>)

/// Print the contents of a container.
#define cinch_container_info(banner, container, delimiter)                     \
  cinch_container_info_impl(banner, container, delimiter,                      \
    cinch::noop_bool<true>)

/// Print a warning message.
#define cinch_warn(message)                                                    \
  cinch_warn_impl(message, cinch::noop_bool<true>)

#else

// Turn off output for info and warn when debugging is disabled
#define cinch_info(message)
#define cinch_warn(message)

#endif // NDEBUG

/// Print an error message and abort.
#define cinch_error(message)                                                   \
  cinch_error_impl(message, cinch::noop_bool<true>)

/// Assert a test case and abort with an error message if the assertion fails.
#define cinch_assert(test, message)                                            \
  !(test) && cinch_error(message)

#endif // cinch_cinchreporting_h

/*~-------------------------------------------------------------------------~-*
 * Formatting options for vim.
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~-------------------------------------------------------------------------~-*/
