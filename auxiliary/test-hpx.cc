/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

#include <hpx/hpx.hpp>

#include <cstring>
#include <vector>

#if defined(CINCH_ENABLE_MPI)
#include <cstdlib>
#include <mpi.h>
#endif

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

#if defined(CINCH_ENABLE_MPI)
namespace detail {
template<char Delimiter>
struct word_delimited_by : std::string {};

template<char Delimiter>
inline std::istream &
operator>>(std::istream & is, word_delimited_by<Delimiter> & str) {
  std::getline(is, str, Delimiter);
  return is;
}

bool
detect_mpi_environment() {
#if defined(__bgq__)
  // If running on BG/Q, we can safely assume to always run in an
  // MPI environment
  return true;
#else
  static std::vector<std::string> const envvars = {"MV2_COMM_WORLD_RANK",
    "PMI_RANK", "OMPI_COMM_WORLD_SIZE", "ALPS_APP_PE", "PMIX_RANK"};

  for(auto const & envvar : envvars) {
    char * env = std::getenv(envvar.c_str());
    if(env)
      return true;
  }
  return false;
#endif
}
} // namespace detail
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

#if defined(CINCH_ENABLE_MPI)
  if(::detail::detect_mpi_environment()) {
    // This is safe even if the user creates other comms, because we
    // execute this function before handing control over to the user
    // code logic.
    MPI_Barrier(MPI_COMM_WORLD);
  }
#endif
} // print_devel_code_label
#endif

//----------------------------------------------------------------------------//
// Main
//----------------------------------------------------------------------------//

int
main(int argc, char ** argv) {

  int rank = 0;

#if defined(CINCH_ENABLE_MPI)
  bool has_mpi = ::detail::detect_mpi_environment();
  if(has_mpi) {
    // Initialize the MPI runtime
    int provided;
    MPI_Init_thread(&argc, &argv, MPI_THREAD_MULTIPLE, &provided);
    if(provided < MPI_THREAD_MULTIPLE) {
      printf("ERROR: Your implementation of MPI does not support "
             "MPI_THREAD_MULTIPLE which is required for use of "
             "MPI conduit with the HPX-MPI Interop!\n");
    }
    assert(provided == MPI_THREAD_MULTIPLE);

    // Disable XML output, if requested, everywhere but rank 0
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  }

  std::vector<char *> args(argv, argv + argc);
  if(rank > 0) {
    for(auto itr = args.begin(); itr != args.end(); ++itr) {
      if(std::strncmp(*itr, "--gtest_output", 14) == 0) {
        args.erase(itr);
        break;
      } // if
    } // for
  } // if

  argc = static_cast<int>(args.size());
  argv = args.data();
#endif

#if !defined(CINCH_DEVEL_TARGET)
  // Initialize the GTest runtime
  ::testing::InitGoogleTest(&argc, argv);
#endif

  // Initialize tags to output all tag groups from CLOG
  std::string tags("all");

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

#if defined(CINCH_ENABLE_MPI)
    if(has_mpi) {
      MPI_Finalize();
    }
#endif

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

    // Adds a listener to the end.  Google Test takes the ownership.
    listeners.Append(new cinch::listener);

    // Run the tests for this target.
    result = RUN_ALL_TESTS();
#endif
  } // if

#if defined(CINCH_ENABLE_MPI)
  if(has_mpi) {
    // Shutdown the MPI runtime
    MPI_Finalize();
  }
#endif

  return result;
} // main

/*~------------------------------------------------------------------------~--*
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~------------------------------------------------------------------------~--*/
