/*
    :::::::: ::::::::::: ::::    :::  ::::::::  :::    :::
   :+:    :+:    :+:     :+:+:   :+: :+:    :+: :+:    :+:
   +:+           +:+     :+:+:+  +:+ +:+        +:+    +:+
   +#+           +#+     +#+ +:+ +#+ +#+        +#++:++#++
   +#+           +#+     +#+  +#+#+# +#+        +#+    +#+
   #+#    #+#    #+#     #+#   #+#+# #+#    #+# #+#    #+#
    ######## ########### ###    ####  ########  ###    ###

   Copyright (c) 2016, Los Alamos National Security, LLC
   All rights reserved.
                                                                              */
#pragma once

#include "colors.h"
#include "output.h"

#include <iostream>
#include <cstring>

namespace cinch {

struct fatal_handler_t {

  fatal_handler_t(const char * condition, const char * file, int line) {
    std::cerr << CLOG_OUTPUT_RED("ERROR") << ": assertion '" << condition <<
      "' failed in " << CLOG_OUTPUT_CYAN(file << ":" << line) <<
      CLOG_COLOR_YELLOW << " "; 
  } // fatal_handler_t

  ~fatal_handler_t() {
    std::cerr << CLOG_COLOR_PLAIN << std::endl;
    std::exit(1);
  } // ~fatal_handler_t

  std::ostream & stream() {
    return std::cerr;
  } // stream

}; // fatal_handler_t

struct nonfatal_handler_t {

  nonfatal_handler_t(const char * condition, const char * file, int line) {
    std::cerr << CLOG_OUTPUT_YELLOW("WARNING") << ": unexpected '" <<
      condition << "' occurred in " <<
      CLOG_OUTPUT_CYAN(file << ":" << line) << CLOG_COLOR_YELLOW << " "; 
  } // nonfatal_handler_t

  ~nonfatal_handler_t() {
    std::cerr << CLOG_COLOR_PLAIN << std::endl;
  } // ~nonfatal_handler_t

  std::ostream & stream() {
    return std::cerr;
  } // stream

}; // nonfatal_handler_t

inline bool string_compare(const char * lhs, const char * rhs) {
  if(lhs == nullptr) { return rhs == nullptr; }
  if(rhs == nullptr) { return false; }
  return strcmp(lhs, rhs) == 0;
} // string_compare

inline bool string_case_compare(const char * lhs, const char * rhs) {
  if(lhs == nullptr) { return rhs == nullptr; }
  if(rhs == nullptr) { return false; }
  return strcasecmp(lhs, rhs) == 0;
} // string_case_compare

} // namespace cinch

#define EXPECT_TRUE(condition)                                                 \
  (condition) ||                                                               \
  cinch::nonfatal_handler_t(#condition, __FILE__, __LINE__).stream()

#define EXPECT_FALSE(condition)                                                \
  !(condition) ||                                                              \
  cinch::nonfatal_handler_t(#condition, __FILE__, __LINE__).stream()

#define ASSERT_TRUE(condition)                                                 \
  (condition) ||                                                               \
  cinch::fatal_handler_t(#condition, __FILE__, __LINE__).stream()

#define ASSERT_FALSE(condition)                                                \
  !(condition) ||                                                              \
  cinch::fatal_handler_t(#condition, __FILE__, __LINE__).stream()

#define ASSERT_EQ(val1, val2)                                                  \
  ASSERT_TRUE((val1) == (val2))

#define EXPECT_EQ(val1, val2)                                                  \
  EXPECT_TRUE((val1) == (val2))

#define ASSERT_NE(val1, val2)                                                  \
  ASSERT_TRUE((val1) != (val2))

#define EXPECT_NE(val1, val2)                                                  \
  EXPECT_TRUE((val1) != (val2))

#define ASSERT_LT(val1, val2)                                                  \
  ASSERT_TRUE((val1) < (val2))

#define EXPECT_LT(val1, val2)                                                  \
  EXPECT_TRUE((val1) < (val2))

#define ASSERT_LE(val1, val2)                                                  \
  ASSERT_TRUE((val1) <= (val2))

#define EXPECT_LE(val1, val2)                                                  \
  EXPECT_TRUE((val1) <= (val2))

#define ASSERT_GT(val1, val2)                                                  \
  ASSERT_TRUE((val1) > (val2))

#define EXPECT_GT(val1, val2)                                                  \
  EXPECT_TRUE((val1) > (val2))

#define ASSERT_GE(val1, val2)                                                  \
  ASSERT_TRUE((val1) >= (val2))

#define EXPECT_GE(val1, val2)                                                  \
  EXPECT_TRUE((val1) >= (val2))

#define ASSERT_STREQ(str1, str2)                                               \
  cinch::string_compare(str1, str2) ||                                         \
  cinch::fatal_handler_t(str1 " == " str2, __FILE__, __LINE__).stream()

#define EXPECT_STREQ(str1, str2)                                               \
  cinch::string_compare(str1, str2) ||                                         \
  cinch::nonfatal_handler_t(str1 " == " str2, __FILE__, __LINE__).stream()

#define ASSERT_STRNE(str1, str2)                                               \
  !cinch::string_compare(str1, str2) ||                                        \
  cinch::fatal_handler_t(str1 " != " str2, __FILE__, __LINE__).stream()

#define EXPECT_STRNE(str1, str2)                                               \
  !cinch::string_compare(str1, str2) ||                                        \
  cinch::nonfatal_handler_t(str1 " != " str2, __FILE__, __LINE__).stream()

#define ASSERT_STRCASEEQ(str1, str2)                                           \
  cinch::string_case_compare(str1, str2) ||                                    \
  cinch::fatal_handler_t(str1 " == " str2 " (case insensitive)",               \
    __FILE__, __LINE__).stream()

#define EXPECT_STRCASEEQ(str1, str2)                                           \
  cinch::string_case_compare(str1, str2) ||                                    \
  cinch::nonfatal_handler_t(str1 " == " str2 " (case insensitive)",            \
    __FILE__, __LINE__).stream()

#define ASSERT_STRCASENE(str1, str2)                                           \
  !cinch::string_case_compare(str1, str2) ||                                   \
  cinch::fatal_handler_t(str1 " != " str2 " (case insensitive)",               \
    __FILE__, __LINE__).stream()

#define EXPECT_STRCASENE(str1, str2)                                           \
  !cinch::string_case_compare(str1, str2) ||                                   \
  cinch::nonfatal_handler_t(str1 " != " str2 " (case insensitive)",            \
    __FILE__, __LINE__).stream()

// Provide access to the output stream to allow user to capture output
#define CINCH_CAPTURE() \
  cinch::test_output_t::instance().get_stream()

// Return captured output as a std::string
#define CINCH_DUMP() \
  cinch::test_output_t::instance().get_buffer()

// Compare captured output to a blessed file
#define CINCH_EQUAL_BLESSED(f) \
  cinch::test_output_t::instance().equal_blessed((f))

// Write captured output to file
#define CINCH_WRITE(f) \
  cinch::test_output_t::instance().to_file((f))

// Dump captured output on failure
#if !defined(_MSC_VER)
  #define CINCH_ASSERT(ASSERTION, ...) \
  ASSERT_ ## ASSERTION(__VA_ARGS__) << CINCH_DUMP()
#else
  // MSVC has a brain-dead preprocessor...
  #define CINCH_ASSERT(ASSERTION, x, y) \
    ASSERT_ ## ASSERTION(x, y) << CINCH_DUMP()
#endif

// Dump captured output on failure
#if !defined(_MSC_VER)
  #define CINCH_EXPECT(EXPECTATION, ...) \
  EXPECT_ ## EXPECTATION(__VA_ARGS__) << CINCH_DUMP()
#else
  // MSVC has a brain-dead preprocessor...
  #define CINCH_EXPECT(EXPECTATION, x, y) \
    EXPECT_ ## EXPECTATION(x, y) << CINCH_DUMP()
#endif

// compare collections with varying levels of assertions
#define CINCH_CHECK_EQUAL_COLLECTIONS(...) \
  cinch::CheckEqualCollections(__VA_ARGS__)

#define CINCH_ASSERT_EQUAL_COLLECTIONS(...) \
  ASSERT_TRUE( cinch::CheckEqualCollections(__VA_ARGS__) << CINCH_DUMP()

#define CINCH_EXPECT_EQUAL_COLLECTIONS(...) \
  EXPECT_TRUE( cinch::CheckEqualCollections(__VA_ARGS__) ) << CINCH_DUMP()
