/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

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
// Implement a function to print test information for the user.
//----------------------------------------------------------------------------//

#if defined(CINCH_DEVEL_TARGET)
void
print_devel_code_label(std::string name) {
  // Print some test information.
  clog(info) << OUTPUT_LTGREEN("Executing development target " << name)
             << std::endl;
} // print_devel_code_label
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
// Main
//----------------------------------------------------------------------------//

int
main(int argc, char ** argv) {

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
  store(parse_command_line(argc, argv, desc), vm);
  notify(vm);

  if(vm.count("help")) {
    std::cout << desc << std::endl;
    return 1;
  } // if
#endif // ENABLE_BOOST
  int result(0);

  if(tags == "0") {
    // Output the available tags
    std::cout << "Available tags (CLOG):" << std::endl;

    for(auto t : clog_tag_map()) {
      std::cout << "  " << t.first << std::endl;
    } // for
  }
  else {
    // Initialize the cinchlog runtime
    clog_init(tags);

    // Call the user-provided initialization function
    driver_initialization(argc, argv);

#if defined(CINCH_DEVEL_TARGET)
    // Perform test initialization.
    cinch_devel_code_init(print_devel_code_label);

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

  return result;
} // main

/*~------------------------------------------------------------------------~--*
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~------------------------------------------------------------------------~--*/
