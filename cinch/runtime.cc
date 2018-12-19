/*
    :::::::: ::::::::::: ::::    :::  ::::::::  :::    :::
   :+:    :+:    :+:     :+:+:   :+: :+:    :+: :+:    :+:
   +:+           +:+     :+:+:+  +:+ +:+        +:+    +:+
   +#+           +#+     +#+ +:+ +#+ +#+        +#++:++#++
   +#+           +#+     +#+  +#+#+# +#+        +#+    +#+
   #+#    #+#    #+#     #+#   #+#+# #+#    #+# #+#    #+#
    ######## ########### ###    ####  ########  ###    ###

   Copyright (c) 2016, Los Alamos National Security, LLC
   All rights reserved.
                                                                              */

/*! @file */

#include <cinch-config.h>
#include <cinch/runtime.h>

#include <iostream>
#include <string>

#if defined(CINCH_ENABLE_BOOST)
  #include <boost/program_options.hpp>
  using namespace boost::program_options;
#endif

using namespace cinch;

/*!
  The main function makes use of Boost program options (optionally). These
  allow the user to control output from clog. It is also possible to add
  additional command-line options.
 */

int main(int argc, char ** argv) {

  runtime_t & runtime_ = runtime_t::instance();

#if defined(CINCH_ENABLE_BOOST)
  std::string program(argv[0]);
  options_description desc(program.substr(program.find('/')+1).c_str());

    // Add command-line options
  desc.add_options()
    ("help,h", "Print this message and exit.")
    ;

  // Invoke add options functions
  runtime_.add_options(desc);

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
    std::cout << std::endl << "Unrecognized options: ";
    for ( int i=0; i<unrecog_options.size(); ++i ) {
      std::cout << unrecog_options[i] << " ";
    }
    std::cout << std::endl << std::endl << desc << std::endl;
    return 1;
  } // if

  if(vm.count("help")) {
    std::cout << desc << std::endl;
    return 1;
  } // if
#endif

  // Invoke registered runtime initializations
#if defined(CINCH_ENABLE_BOOST)
  runtime_.initialize_runtimes(argc, argv, parsed);
#else
  runtime_.initialize_runtimes(argc, argv);
#endif

  // Invoke the primary callback
  int result = runtime_.driver()(argc, argv);

  // Invoke registered runtime finalizations
  runtime_.finalize_runtimes(argc, argv, exit_mode_t::success);

  return result;
} // main
