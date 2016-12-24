/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

#include <gtest/gtest.h>
#include <mpi.h>
#include <cstring>
#include <vector>

#if defined(ENABLE_GFLAGS)
  #include <gflags/gflags.h>
  DEFINE_string(groups, "all", "Specify the active tag groups");
#endif // ENABLE_GFLAGS

#include "cinchtest.h"

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
  std::string groups = "all";

#if defined(ENABLE_GFLAGS)
  // Send any unprocessed arguments to GFlags
  gflags::ParseCommandLineFlags(&argc, &argv, true);
#endif // ENABLE_GFLAGS

  // Initialize the cinchlog runtime
  clog_init(groups);

  ::testing::TestEventListeners& listeners =
    ::testing::UnitTest::GetInstance()->listeners();

  // Adds a listener to the end.  Google Test takes the ownership.
  listeners.Append(new cinch::listener);

  int result = RUN_ALL_TESTS();

  // Shutdown the MPI runtime
  MPI_Finalize();

  return result;

} // main

/*~------------------------------------------------------------------------~--*
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~------------------------------------------------------------------------~--*/
