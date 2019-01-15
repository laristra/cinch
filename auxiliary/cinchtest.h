#ifndef cinchtest_h
#define cinchtest_h

#include "../cinch/clog.h"
#include "check_collections.h"
#include "listener.h"
#include "output.h"

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

#endif // cinchtest_h
