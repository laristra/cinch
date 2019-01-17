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
#pragma once

/*! @file */

#include <cinch-config.h>

#if defined(CINCH_ENABLE_BOOST)
  #include <boost/program_options.hpp>
  using namespace boost::program_options;
#endif

#include <functional>
#include <string>
#include <vector>

namespace cinch {

enum exit_mode_t : size_t {
  success,
  unrecognized_option,
  help
}; // enum exit_mode_t

/*!
  Type to define runtime initialization and finalization handlers.
 */

struct runtime_handler_t {
#if defined(CINCH_ENABLE_BOOST)
  std::function<int(int, char **, variables_map &)> initialize;
#else
  std::function<int(int, char **)> initialize;
#endif
  std::function<int(int, char **, exit_mode_t)> finalize;
#if defined(CINCH_ENABLE_BOOST)
  std::function<void(options_description &)> add_options =
    [](options_description &){};
#endif  
}; // struct runtime_handler_t

/*!
 */

struct runtime_t {

  static runtime_t & instance() {
    static runtime_t r;
    return r;
  } // instance

  std::string const & program() const { return program_; }
  std::string & program() { return program_; }

  bool register_driver(std::function<int(int, char **)> const & driver) {
    driver_ = driver;
    return true;
  } // register_driver

  std::function<int(int, char **)> const & driver() const {
    return driver_;
  } // driver

  /*!
    Append the given runtime handler to the vector of handlers. Handlers
    will be executed in the order in which they are appended.
   */
  bool append_runtime_handler(runtime_handler_t const & handler) {
    handlers_.push_back(handler);
    return true;
  } // register_runtime_handler

  /*!
    Access the runtime handler vector.
   */

  std::vector<runtime_handler_t> & runtimes() {
    return handlers_;
  } // runtimes

  /*!
    Invoke runtime options callbacks.
   */

#if defined(CINCH_ENABLE_BOOST)
  void add_options(options_description & desc) {
    for(auto r: handlers_) {
      r.add_options(desc);
    } // for
  } // add_options
#endif // CINCH_ENABLE_BOOST

  /*!
    Invoke runtime intiailzation callbacks.
   */

#if defined(CINCH_ENABLE_BOOST)
  int initialize_runtimes(int argc, char ** argv, variables_map & vm) {
    int result{0};

    for(auto r: handlers_) {
      result |= r.initialize(argc, argv, vm);
    } // for

    return result;
  } // initialize_runtimes
#else
  int initialize_runtimes(int argc, char ** argv) {
    int result{0};

    for(auto r: handlers_) {
      result |= r.initialize(argc, argv);
    } // for

    return result;
  } // initialize_runtimes
#endif

  /*!
    Invoke runtime finalization callbacks.
   */

  int finalize_runtimes(int argc, char ** argv, exit_mode_t mode) {
    int result{0};

    for(auto r: handlers_) {
      result |= r.finalize(argc, argv, mode);
    } // for

    return result;
  } // finalize_runtimes

private:

  runtime_t() {}

  ~runtime_t() {}

  // These are deleted because this type is a singleton, i.e.,
  // we don't want anyone to be able to make copies or references.

  runtime_t(const runtime_t &) = delete;
  runtime_t & operator=(const runtime_t &) = delete;
  runtime_t(runtime_t &&) = delete;
  runtime_t & operator=(runtime_t &&) = delete;

  std::string program_;
  std::function<int(int, char **)> driver_;
  std::vector<runtime_handler_t> handlers_;

}; // runtime_t

} // namespace cinch

/*!
  @def cinch_register_runtime_driver(driver)

  Register the primary runtime driver function.

  @param driver The primary driver with a 'int(int, char **)' signature
                that should be invoked by the FleCSI runtime.
 */

#define cinch_register_runtime_driver(driver)                                  \
  /* MACRO IMPLEMENTATION */                                                   \
                                                                               \
  inline bool cinch_registered_driver_##driver =                               \
    cinch::runtime_t::instance().register_driver(driver)

/*!
  @def cinch_register_runtime_handler(handler)

  Register a runtime handler with the FleCSI runtime. Runtime handlers
  are invoked at fixed control points in the FleCSI control model for
  add options, initialization, and finalization. The finalization function
  has an additional argument that specifies the exit mode. Adding options
  is only enabled with CINCH_ENABLE_BOOST.

  @param handler A runtime_handler_t that references the appropriate
                 initialize, finalize, and add_options functions.
 */

#define cinch_append_runtime_handler(handler)                                  \
  /* MACRO DEFINITION */                                                       \
                                                                               \
  inline bool cinch_append_runtime_handler_##handler =                         \
    cinch::runtime_t::instance().append_runtime_handler(handler)
