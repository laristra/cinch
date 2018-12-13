/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2016 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#include <boost/program_options.hpp>

// Uncomment these to enable color output and tags
// #define CLOG_COLOR_OUTPUT 
// #define CLOG_ENABLE_TAGS

#include <clog.h>

using namespace boost::program_options;

clog_register_tag(tag1);
clog_register_tag(tag2);

int main(int argc, char ** argv) {

  int rank(0);

#if defined(CLOG_ENABLE_MPI)
  MPI_Init(&argc, &argv);

  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
#endif

  // Initialize tags to output all tag groups from clog
  std::string tags("all");

  // Create program options object
  options_description desc("Cinch test options");

  // Add command-line options
  desc.add_options()
    ("help,h", "Print this message and exit.")
    ("tags,t", value(&tags)->implicit_value("0"),
      "Enable the specified output tags, e.g., --tags=tag1,tag2."
      " Passing --tags by itself will print the available tags.")
    ;
  variables_map vm;
  parsed_options parsed =
    command_line_parser(argc, argv).options(desc).allow_unregistered().run();
  store(parsed, vm);

  notify(vm);

  // Gather the unregistered options, if there are any, print a help message
  // and die nicely.
  std::vector<std::string> unrecog_options =
    collect_unrecognized(parsed.options, include_positional);

  if(unrecog_options.size()) {
    if(rank == 0) {
      std::cout << std::endl << "Unrecognized options: ";
      for ( int i=0; i<unrecog_options.size(); ++i ) {
        std::cout << unrecog_options[i] << " ";
      }
      std::cout << std::endl << std::endl << desc << std::endl;
    } // if

#if defined(CLOG_ENABLE_MPI)
    MPI_Finalize();
#endif

    return 1;
  } // if

  if(vm.count("help")) {
    if(rank == 0) {
      std::cout << desc << std::endl;
    } // if

#if defined(CLOG_ENABLE_MPI)
    MPI_Finalize();
#endif

    return 1;
  } // if

  // Test tags
  if(tags == "0") {
    std::cout << "Available tags (clog):" << std::endl;

    for(auto t: clog_tag_map()) {
      std::cout << " " << t.first << std::endl;
    } // for

    return 1;
  }
  else {
    // Initialize clog runtime
    clog_init(tags);
  } // if

  {
    clog_tag_guard(tag1);

    clog(info) << "In tag guard for tag1" << std::endl;
    //clog_info("In tag guard for tag1" << std::endl);

    for(auto i{0}; i<10; ++i) {
      clog(info) << "i: " << i << std::endl;
      usleep(10000);
      //clog_info("i: " << i << std::endl);
    } // for
  } // scope

  {
    clog_tag_guard(tag2);

    clog(trace) << "In tag guard for tag2" << std::endl;
    //clog_trace("In tag guard for tag2" << std::endl);

    for(auto i{0}; i<10; ++i) {
      clog(trace) << "i: " << i << std::endl;
      //clog_trace("i: " << i << std::endl);
    } // for
  } // scope

#if defined(CLOG_ENABLE_MPI)
  MPI_Finalize();
#endif

  clog_fatal("testing fatal error");

  return 0;
} // main

/*~-------------------------------------------------------------------------~-*
 * Formatting options for vim.
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~-------------------------------------------------------------------------~-*/
