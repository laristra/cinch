/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

#include <cstring>
#include <gtest/gtest.h>
#include <mpi.h>

#include <vector>

// Include and flag definitions for GFlags.
#if defined(ENABLE_GFLAGS)
  #include <gflags/gflags.h>
  DEFINE_string(active, "none", "Specify the active tag groups");
  DEFINE_bool(tags, false, "List available tag groups and exit.");
#endif // ENABLE_GFLAGS

#include "cinchtest.h"

//----------------------------------------------------------------------------//
// Main
//----------------------------------------------------------------------------//

int main(int argc, char ** argv) {

  // Initialize the MPI runtime
  MPI_Init(&argc, &argv);

  // Disable XML output, if requested, everywhere but rank 0
  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  std::vector<char *> args(argv, argv+argc);
  if (rank > 0) {
    for (auto itr = args.begin(); itr != args.end(); ++itr) {
      if (std::strncmp(*itr, "--gtest_output", 14) == 0) {
        args.erase(itr);
        break;
      } // if
    } // for
  } // if

  argc = args.size();
  argv = args.data();

  // Initialize the GTest runtime
  ::testing::InitGoogleTest(&argc, argv);

  // This is used for initialization of clog if gflags is not enabled.
  std::string active("none");
  bool tags(false);

#if defined(ENABLE_GFLAGS)
  // Usage
  gflags::SetUsageMessage("[options]");

  // Send any unprocessed arguments to GFlags
  gflags::ParseCommandLineFlags(&argc, &argv, true);

  // Get the flags
  active = FLAGS_active;
  tags = FLAGS_tags;
#endif // ENABLE_GFLAGS

  int result(0);

  if(tags != false) {
    // Output the available tags
    if(rank == 0) {
      std::cout << "Available tags (CLOG):" << std::endl;
      for(auto t: clog_tag_map()) {
        std::cout << "  " << t.first << std::endl;
      } // for
    } // if
  }
  else {
    // Initialize the cinchlog runtime
    clog_init(active);

    ::testing::TestEventListeners& listeners =
      ::testing::UnitTest::GetInstance()->listeners();

    // Adds a listener to the end.  Google Test takes the ownership.
    listeners.Append(new cinch::listener);

    // Run the tests for this target
    result = RUN_ALL_TESTS();
  } // if

  // Shutdown the MPI runtime
  MPI_Finalize();

  return result;

} // main

/*~------------------------------------------------------------------------~--*
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~------------------------------------------------------------------------~--*/
