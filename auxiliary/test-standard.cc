/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

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

//----------------------------------------------------------------------------//
// Implement a function to print test information for the user.
//----------------------------------------------------------------------------//

#if defined(CINCH_DEVEL_TEST)
void print_devel_code_label(std::string name) {
  // Print some test information.
  clog(info) <<
    OUTPUT_LTGREEN("Executing development test " << name) << std::endl;
} // print_devel_code_label
#endif

//----------------------------------------------------------------------------//
// Main
//----------------------------------------------------------------------------//

int main(int argc, char ** argv) {
  
#if !defined(CINCH_DEVEL_TEST)
  // Initialize the GTest runtime
  ::testing::InitGoogleTest(&argc, argv);
#endif

  // These are used for initialization of clog if gflags is not enabled.
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
    std::cout << "Available tags (CLOG):" << std::endl;

    for(auto t: clog_tag_map()) {
      std::cout << "  " << t.first << std::endl;
    } // for
  }
  else {
    // Initialize the cinchlog runtime
    clog_init(active);

#if defined(CINCH_DEVEL_TEST)
    // Perform test initialization.
    user_devel_code_init(print_devel_code_label);

    // Run the devel test.
    user_devel_code_logic();
#else
    // Get GTest listeners
    ::testing::TestEventListeners& listeners =
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
