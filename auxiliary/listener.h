/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2015 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#ifndef cinch_listener_h
#define cinch_listener_h

#include <gtest/gtest.h>
#include "output.h"

namespace cinch {

class listener : public ::testing::EmptyTestEventListener
{
public:

  virtual void OnTestStart(const ::testing::TestInfo& test_info) {
  } // OnTestStart

  virtual void OnTestPartResult(
    const ::testing::TestPartResult& test_part_result) {
  } // OnTestPartResult

  virtual void OnTestEnd(const ::testing::TestInfo& test_info) {
  } // OnTestEnd

}; // class listener

} // namespace cinch

#endif // cinch_listener_h

/*~-------------------------------------------------------------------------~-*
 * Formatting options for vim.
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~-------------------------------------------------------------------------~-*/
