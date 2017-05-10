/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

#ifdef ENABLE_MPI
#include <mpi.h>
#endif
#include <legion.h>

// Include and flag definitions for GFlags.
#if defined(ENABLE_GFLAGS)
  #include <gflags/gflags.h>
  DEFINE_string(active, "none", "Specify the active tag groups");
  DEFINE_bool(tags, false, "List available tag groups and exit.");
#endif // ENABLE_GFLAGS

// This define lets us use the same test driver for gtest and internal
// devel tests.
#if defined(CINCH_DEVEL_TEST)
  #include "cinchdevel.h"
#else
  #include <gtest/gtest.h>
  #include "cinchtest.h"
#endif

#define _UTIL_STRINGIFY(s) #s
#define EXPAND_AND_STRINGIFY(s) _UTIL_STRINGIFY(s)

#ifndef TEST_INIT
  #include "test-init.h"
#else
  #include EXPAND_AND_STRINGIFY(TEST_INIT)
#endif

#undef EXPAND_AND_STRINGIFY
#undef _UTIL_STRINGIFY

//----------------------------------------------------------------------------//
// Implement a function to print test information for the user.
//----------------------------------------------------------------------------//

#if defined(CINCH_DEVEL_TEST)
void print_devel_code_label(std::string name) {
  // Print some test information.
  clog_rank(info, 0) <<
    OUTPUT_LTGREEN("Executing development test " << name) << std::endl;

#if defined(ENABLE_MPI)
  // This is safe even if the user creates other comms, because we
  // execute this function before handing control over to the user
  // code logic.
  MPI_Barrier(MPI_COMM_WORLD);
#endif // ENABLE_MPI
} // print_devel_code_label
#endif

//----------------------------------------------------------------------------//
// Main
//----------------------------------------------------------------------------//

int main(int argc, char ** argv) {

#if defined(ENABLE_MPI)
  // Get the MPI version
  int version, subversion;
  MPI_Get_version(&version, &subversion);

#if defined(GASNET_CONDUIT_MPI)
  if(version==3 && subversion>0) {
    int provided;
    MPI_Init_thread(&argc, &argv, MPI_THREAD_MULTIPLE, &provided);
    // If you fail this assertion, then your version of MPI
    // does not support calls from multiple threads and you
    // cannot use the GASNet MPI conduit
    if (provided < MPI_THREAD_MULTIPLE)
      printf("ERROR: Your implementation of MPI does not support "
           "MPI_THREAD_MULTIPLE which is required for use of the "
           "GASNet MPI conduit with the Legion-MPI Interop!\n");
    assert(provided == MPI_THREAD_MULTIPLE);
  }
  else {
    // Initialize the MPI runtime
    MPI_Init(&argc, &argv);
  } // if
#else
   MPI_Init(&argc, &argv);
#endif

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

#endif // ENABLE_MPI

#if !defined(CINCH_DEVEL_TEST)
  // Initialize the GTest runtime
  ::testing::InitGoogleTest(&argc, argv);
#endif

  // This is used for initialization of clog if gflags is not enabled.
  std::string active("all");
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

#if defined(ENABLE_MPI)
    // Output the available tags
		if(rank == 0) {
#endif
			std::cout << "Available tags (CLOG):" << std::endl;

			for(auto t: clog_tag_map()) {
				std::cout << "  " << t.first << std::endl;
			} // for
#if defined(ENABLE_MPI)
		} // if
#endif
  }
  else {
    // Initialize the cinchlog runtime
    clog_init(active);

    // Call the user-provided initialization function
    test_init(argc, argv);

#if defined(CINCH_DEVEL_TEST)
    // Perform test initialization.
    cinch_devel_code_init(print_devel_code_label);

    // Run the devel test.
    user_devel_code_logic();
#else
    ::testing::TestEventListeners &listeners =
      ::testing::UnitTest::GetInstance()->listeners();

    // Adds a listener to the end.  Google Test takes the ownership.
    listeners.Append(new cinch::listener);

    // Run the tests for this target.
    result = RUN_ALL_TESTS();
#endif
  } // if

#if defined(ENABLE_MPI)
  // FIXME: This is some kind of GASNet bug (or maybe Legion).
  // Shutdown the MPI runtime
#ifndef GASNET_CONDUIT_MPI
  MPI_Finalize();
#endif
#endif // ENABLE_MPI

  return result;

} // main

/*~------------------------------------------------------------------------~--*
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~------------------------------------------------------------------------~--*/
