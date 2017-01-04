/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

#include <gtest/gtest.h>

#if defined(ENABLE_GFLAGS)
  #include <gflags/gflags.h>
  DEFINE_string(groups, "all", "Specify the active tag groups");
#endif // ENABLE_GFLAGS

#include "cinchtest.h"

int main(int argc, char ** argv) {
  
  // Initialize the GTest runtime
  ::testing::InitGoogleTest(&argc, argv);

  // This is used for initialization of clog if gflags is not enabled.
  std::string groups = "all";

#if defined(ENABLE_GFLAGS)
  // Send any unprocessed arguments to GFlags
  gflags::ParseCommandLineFlags(&argc, &argv, true);

  // Get the tag groups from gflags
  groups = FLAGS_groups;
#endif // ENABLE_GFLAGS

  // Initialize the cinchlog runtime
  clog_init(groups);

  ::testing::TestEventListeners& listeners =
    ::testing::UnitTest::GetInstance()->listeners();

  // Adds a listener to the end.  Google Test takes the ownership.
  listeners.Append(new cinch::listener);

  return RUN_ALL_TESTS();

} // main

/*~------------------------------------------------------------------------~--*
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~------------------------------------------------------------------------~--*/
