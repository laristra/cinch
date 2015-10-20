/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#include <gtest/gtest.h>
#include <memory>
#include <regex>
#include <iostream>
#include <fstream>

#ifndef cinchtest_h
#define cinchtest_h

namespace cinch {

class test_output_t
{
public:

  static test_output_t & instance() {
    static test_output_t g;
    return g;
  } // instance

  std::ostream & get_stream() {
    return *stream_;
  } // get_stream

  void to_file(const std::string & filename) {
    to_file(filename.c_str());
  } // to_file

  void to_file(const char * filename) {
    std::ofstream f(filename);

    if(not f.good()) {
      std::cerr << "Failed to open " << filename << std::endl;
      std::exit(1);
    } // if

    f << default_.rdbuf();
  } // to_file

  void fail() {
    FAIL() << default_.rdbuf();
  } // fail

  bool equal_blessed(const char * filename) {
    std::string testdir_filename("test/");
    testdir_filename += filename;

    // save test output to .current for updates
    std::regex suffix("\\..*");
    std::string save_output =
      std::regex_replace(testdir_filename, suffix, ".current");
    to_file(save_output);

    std::ifstream f(testdir_filename);
    
    if(not f.good()) {
      std::cerr << "Failed to open " << filename << std::endl;
      std::exit(1);
    } // if

    std::stringstream ss;
    ss << f.rdbuf();

    if(default_.str().compare(ss.str()) == 0) {
      return true;
    } // if

    return false;
  } // equal_blessed

private:

  test_output_t()
    : stream_(new std::ostream(default_.rdbuf())) {
  } // test_output_t

  std::stringstream default_;
  std::shared_ptr<std::ostream> stream_;

}; // class test_output_t

} // namespace cinch

#define CINCH_CAPTURE() \
  cinch::test_output_t::instance().get_stream()

#define CINCH_EQUAL_BLESSED(f) \
  cinch::test_output_t::instance().equal_blessed((f))

#define CINCH_WRITE(f) \
  cinch::test_output_t::instance().to_file((f))

#define CINCH_FAIL() \
  cinch::test_output_t::instance().fail()

#endif // cinchtest_h

/*~-------------------------------------------------------------------------~-*
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~-------------------------------------------------------------------------~-*/
