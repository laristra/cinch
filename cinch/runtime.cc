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

#include <cinch-config.h>
#include <cinch/runtime.h>

#include <iostream>
#include <string>

#if defined(CINCH_ENABLE_BOOST)
  #include <boost/program_options.hpp>
  using namespace boost::program_options;
#endif

using namespace cinch;

int main(int argc, char ** argv) {

  runtime_t & runtime_ = runtime_t::instance();

#if defined(CINCH_ENABLE_BOOST)
  std::string program(argv[0]);
  program = "Basic Options (" + program.substr(program.rfind('/')+1) + ")";
  options_description desc(program.c_str());

  // Add help option
  desc.add_options()("help,h", "Print this message and exit.");

  // Invoke add options functions
  runtime_.add_options(desc);

  variables_map vm;
  parsed_options parsed =
    command_line_parser(argc, argv).options(desc).allow_unregistered().run();
  store(parsed, vm);

  notify(vm);

#endif

  // Invoke registered runtime initializations
  if(
#if defined(CINCH_ENABLE_BOOST)
    runtime_.initialize_runtimes(argc, argv, vm)
#else
    runtime_.initialize_runtimes(argc, argv)
#endif
  ) {
    runtime_.finalize_runtimes(argc, argv, exit_mode_t::option_exit);
    return 1;
  } // if

#if defined(CINCH_ENABLE_BOOST)
  // Gather the unregistered options, if there are any, print a help message
  // and die nicely.
  std::vector<std::string> unrecog_options =
    collect_unrecognized(parsed.options, include_positional);

  if(unrecog_options.size()) {
    if(runtime_.join_output()) {
      std::cout << std::endl << "Unrecognized options: ";
      for(size_t i=0; i<unrecog_options.size(); ++i) {
        std::cout << unrecog_options[i] << " ";
      }
      std::cout << std::endl << std::endl << desc << std::endl;
    } // if

    // runtime_.unrecognized_option(argc, argv, ...); 
    return 1;
  } // if

  if(vm.count("help")) {
    if(runtime_.join_output()) {
      std::cout << desc << std::endl;
    } // if

    runtime_.finalize_runtimes(argc, argv, exit_mode_t::help);
    return 1;
  } // if
#endif

  // Invoke the primary callback
#if defined(CINCH_ENABLE_BOOST)
  int result = runtime_.driver()(argc, argv, vm);
#else
  int result = runtime_.driver()(argc, argv);
#endif

  // Invoke registered runtime finalizations
  if(runtime_.finalize_runtimes(argc, argv, exit_mode_t::success)) {
    return 1;
  } // if

  return result;
} // main
