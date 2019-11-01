/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

#include <cstring>
#include <mpi.h>
#include <vector>

// Boost command-line options
#if defined(ENABLE_BOOST)
#include <boost/program_options.hpp>
using namespace boost::program_options;
#endif

// This define lets us use the same test driver for gtest and internal
// devel tests.
#if defined(CINCH_DEVEL_TARGET)
#include "cinchdevel.h"
#else
#include "cinchtest.h"
#include <gtest/gtest.h>
#endif

#if defined (ENABLE_KOKKOS)
#include <Kokkos_Core.hpp>
#endif

//----------------------------------------------------------------------------//
// Allow extra initialization steps to be added by the user.
//----------------------------------------------------------------------------//

#if defined(CINCH_OVERRIDE_DEFAULT_INITIALIZATION_DRIVER)
int driver_initialization(int argc, char ** argv);
#else
inline int
driver_initialization(int argc, char ** argv) {
  return 0;
}
#endif

//----------------------------------------------------------------------------//
// Implement a function to print test information for the user.
//----------------------------------------------------------------------------//

#if defined(CINCH_DEVEL_TARGET)
void
print_devel_code_label(std::string name) {
  // Print some test information to the root rank.
  clog_rank(info, 0) << OUTPUT_LTGREEN("Executing development target " << name)
                     << std::endl;

  // This is safe even if the user creates other comms, because we
  // execute this function before handing control over to the user
  // code logic.
  MPI_Barrier(MPI_COMM_WORLD);
} // print_devel_code_label
#endif

//----------------------------------------------------------------------------//
// Main
//----------------------------------------------------------------------------//

int
main(int argc, char ** argv) {

#if defined(CINCH_ENABLE_MPI_THREAD_MULTIPLE)
  // Get the MPI version
  int version, subversion;
  MPI_Get_version(&version, &subversion);

  if(version == 3 && subversion > 0) {
    int provided;
    MPI_Init_thread(&argc, &argv, MPI_THREAD_MULTIPLE, &provided);
    // If you fail this assertion, then your version of MPI
    // does not support calls from multiple threads and you
    // cannot use the GASNet MPI conduit
    if(provided < MPI_THREAD_MULTIPLE)
      printf("ERROR: Your implementation of MPI does not support "
             "MPI_THREAD_MULTIPLE which is required for use of the "
             "GASNet MPI conduit with the Legion-MPI Interop!\n");
    assert(provided == MPI_THREAD_MULTIPLE);
  }
  else {
    printf("ERROR: Your implementation of MPI does not support "
           "MPI_THREAD_MULTIPLE which is required for use of the "
           "GASNet MPI conduit with the Legion-MPI Interop!\n");
  } // if
#else
  // Initialize the MPI runtime
  MPI_Init(&argc, &argv);
#endif // CINCH_ENABLE_MPI_THREAD_MULTIPLE

  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

#if !defined(CINCH_DEVEL_TARGET)
  // Initialize the GTest runtime
  ::testing::InitGoogleTest(&argc, argv);
#endif

  // Initialize tags to output all tag groups from CLOG
  std::string tags("all");

#if defined (ENABLE_KOKKOS)
  Kokkos::initialize(argc, argv);
#endif

#if defined(ENABLE_BOOST)
  options_description desc("Cinch test options");

  // Add command-line options
  desc.add_options()("help,h", "Print this message and exit.")("tags,t",
    value(&tags)->implicit_value("0"),
    "Enable the specified output tags, e.g., --tags=tag1,tag2."
    " Passing --tags by itself will print the available tags.");
  variables_map vm;
  parsed_options parsed =
    command_line_parser(argc, argv).options(desc).allow_unregistered().run();
  store(parsed, vm);

  notify(vm);

  if(vm.count("help")) {
    if(rank == 0) {
      std::cout << desc << std::endl;
    } // if

    MPI_Finalize();

    return 1;
  } // if
#endif // ENABLE_BOOST

  int result(0);

  if(tags == "0") {
    // Output the available tags
    if(rank == 0) {
      std::cout << "Available tags (CLOG):" << std::endl;

      for(auto t : clog_tag_map()) {
        std::cout << "  " << t.first << std::endl;
      } // for
    } // if
  }
  else {
    // Initialize the cinchlog runtime
    clog_init(tags);

#if defined(CINCH_DEVEL_TARGET)
    // Perform test initialization.
    cinch_devel_code_init(print_devel_code_label);
#endif

    // Call the user-provided initialization function
    driver_initialization(argc, argv);

#if defined(CINCH_DEVEL_TARGET)
    // Run the devel test.
    user_devel_code_logic();
#else
    // Get GTest listeners
    ::testing::TestEventListeners & listeners =
      ::testing::UnitTest::GetInstance()->listeners();

    // Disable XML output, if requested, everywhere but rank 0
    if(rank > 0) {
      delete listeners.Release(listeners.default_xml_generator());
    } // if

    // Adds a listener to the end.  Google Test takes the ownership.
    listeners.Append(new cinch::listener);

    // Run the tests for this target.
    result = RUN_ALL_TESTS();
#endif
  } // if

#if defined (ENABLE_KOKKOS)
  Kokkos::finalize();
#endif

  // Shutdown the MPI runtime
  MPI_Finalize();

  return result;
} // main

/*~------------------------------------------------------------------------~--*
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~------------------------------------------------------------------------~--*/
