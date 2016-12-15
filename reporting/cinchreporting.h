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
// No-op function to return a boolean value.
//
// \tparam B The boolean value to return, i.e., true or false.
///
template<
  bool B
>
inline
bool
output_bool()
{
  return B;
} // output_bool

///
// No-op function to return a boolean value.
//
// \tparam B The boolean value to return, i.e., true or false.
// \tparam C The container type.
///
template<
  bool B,
  typename C = size_t
>
inline
bool
index_bool(C c = 0)
{
  return B;
} // output_bool

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
#define cinch_info_impl(message, predicate, ...)                               \
  predicate(__VA_ARGS__) &&                                                    \
    std::cout << OUTPUT_GREEN("Info ") << OUTPUT_LTGRAY(message) << std::endl

///
/// Print the contents of a container, using the user-provided predicate
/// functions to determine which elements should be output.
///
/// \param banner A string or insertion stream containing the desired
///               message to output at the beginning of the information dump.
/// \param container The container to output. Any container type that
///                  supports range-based for loops is valid.
/// \param delimiter A string or insertion stream containing the desired
///                  formatting delimiter to print between container entries.
/// \param index_predicate A predicate function taking a container
///                        iterate that determines if the iterate
///                        should be included in the output.
/// \param output_predicate A predicate function that determines whether
///                         or not any output should be generated for
///                         the calling runtime instance.
/// \param ... A varidiac argumment list to pass to output_predicate.
///
#define cinch_container_info_impl(banner, container, delimiter,                \
  index_predicate, output_predicate, ...)                                      \
  if(output_predicate(__VA_ARGS__)) {                                          \
    std::cout << OUTPUT_GREEN("Info ") << OUTPUT_LTGRAY(banner) << std::endl;  \
    for(auto c: container) {                                                   \
      index_predicate(c) && std::cout << OUTPUT_LTGRAY(c) << delimiter;        \
    }                                                                          \
    std::cout << std::endl;                                                    \
  }

/// Print a warning message if the predicate evaluates to true.
#define cinch_warn_impl(message, predicate, ...)                               \
  predicate(__VA_ARGS__) &&                                                    \
    std::cout << OUTPUT_BROWN("!Warning!") << std::endl <<                     \
    OUTPUT_BROWN("  Message: ") << OUTPUT_YELLOW(message) << std::endl <<      \
    OUTPUT_LTGRAY("  [") <<                                                    \
      OUTPUT_LTGRAY("line ") << OUTPUT_LTGRAY(__LINE__) << " " <<              \
      OUTPUT_LTGRAY(__FILE__) <<                                               \
    OUTPUT_LTGRAY("] ") << std::endl

/// Print an error message if the predicate evaluates to true and abort.
/// Regardless of the predicate, std::abort() is executed.
#define cinch_error_impl(message, predicate, ...)                              \
  predicate(__VA_ARGS__) &&                                                    \
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
  cinch_info_impl(message, cinch::output_bool<true>)

/// Print the contents of a container.
#define cinch_container_info(banner, container, delimiter)                     \
  cinch_container_info_impl(banner, container, delimiter,                      \
    cinch::index_bool<true>, cinch::output_bool<true>)

/// Print a warning message.
#define cinch_warn(message)                                                    \
  cinch_warn_impl(message, cinch::output_bool<true>)

#else

// Turn off output for info and warn when debugging is disabled
#define cinch_info(message)
#define cinch_warn(message)

#endif // NDEBUG

/// Print an error message and abort.
#define cinch_error(message)                                                   \
  cinch_error_impl(message, cinch::output_bool<true>)

/// Assert a test case and abort with an error message if the assertion fails.
#define cinch_assert(test, message)                                            \
  !(test) && cinch_error(message)

#endif // cinch_cinchreporting_h

/*~-------------------------------------------------------------------------~-*
 * Formatting options for vim.
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~-------------------------------------------------------------------------~-*/
