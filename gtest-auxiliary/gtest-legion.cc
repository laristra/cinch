/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

#include <gtest/gtest.h>

#include "listener.h"

int main(int argc, char ** argv) {
  
  // Initialize the GTest runtime
  ::testing::InitGoogleTest(&argc, argv);

  ::testing::TestEventListeners& listeners =
    ::testing::UnitTest::GetInstance()->listeners();

  // Adds a listener to the end.  Google Test takes the ownership.
  listeners.Append(new cinch::listener);

  return RUN_ALL_TESTS();

} // main

/*~------------------------------------------------------------------------~--*
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~------------------------------------------------------------------------~--*/
