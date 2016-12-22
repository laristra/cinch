/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

#include <gtest/gtest.h>

#define _UTIL_STRINGIFY(s) #s
#define EXPAND_AND_STRINGIFY(s) _UTIL_STRINGIFY(s)

#ifndef GTEST_INIT
  #include "gtest-init.h"
#else
  #include EXPAND_AND_STRINGIFY(GTEST_INIT)
#endif

#undef EXPAND_AND_STRINGIFY
#undef _UTIL_STRINGIFY

#include "listener.h"

int main(int argc, char ** argv) {
  
  // Initialize the GTest runtime
  ::testing::InitGoogleTest(&argc, argv);

  // Get event listeners
  ::testing::TestEventListeners& listeners =
    ::testing::UnitTest::GetInstance()->listeners();

  // Call the user-provided initialization function
  gtest_init(argc, argv);

  // Adds a listener to the end.  Google Test takes the ownership.
  listeners.Append(new cinch::listener);

  return RUN_ALL_TESTS();

} // main

/*~------------------------------------------------------------------------~--*
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~------------------------------------------------------------------------~--*/
