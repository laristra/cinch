/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2015 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#ifndef cinch_cinchdevel_h
#define cinch_cinchdevel_h

#include "../logging/cinchlog.h"

///
/// \file
/// \date Initial file creation: Dec 28, 2016
///

void cinch_devel_code_init(std::function<void(std::string)> func);
void user_devel_code_logic();

#define DEVEL(name)                                                            \
  void cinch_devel_code_init(std::function<void(std::string)>  func) {         \
    func(_clog_stringify(name));                                               \
  }                                                                            \
  void user_devel_code_logic()

#endif // cinch_cinchdevel_h

/*~-------------------------------------------------------------------------~-*
 * Formatting options for vim.
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~-------------------------------------------------------------------------~-*/
