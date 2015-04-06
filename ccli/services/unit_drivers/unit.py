#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from string import Template

unit_template = Template(
"""
/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~--------------------------------------------------------------------------~*/

#include <gtest/gtest.h>

TEST(${CASE}, ${NAME_A}) {

    /* Test Logic: See 'Google Test Macros' section below. */

} // TEST

# if 0 /* Remove guards to create more tests */
TEST(${CASE}, ${NAME_B}) {

    /* Test Logic: See 'Google Test Macros' section below. */

} // TEST

TEST(${CASE}, ${NAME_C}) {

    /* Test Logic: See 'Google Test Macros' section below. */

} // TEST
#endif // if 0

/*----------------------------------------------------------------------------*
 * Google Test Macros
 *
 * Basic Assertions:
 *
 *      ==== Fatal ====             ==== Non-Fatal ====
 *      ASSERT_TRUE(condition);     EXPECT_TRUE(condition)
 *      ASSERT_FALSE(condition);    EXPECT_FALSE(condition)
 *
 * Binary Comparison:
 *
 *      ==== Fatal ====             ==== Non-Fatal ====
 *      ASSERT_EQ(val1, val2);      EXPECT_EQ(val1, val2)
 *      ASSERT_NE(val1, val2);      EXPECT_NE(val1, val2)
 *      ASSERT_LT(val1, val2);      EXPECT_LT(val1, val2)
 *      ASSERT_LE(val1, val2);      EXPECT_LE(val1, val2)
 *      ASSERT_GT(val1, val2);      EXPECT_GT(val1, val2)
 *      ASSERT_GE(val1, val2);      EXPECT_GE(val1, val2)
 *
 * String Comparison:
 *
 *  ==== Fatal ====                     ==== Non-Fatal ====
 *  ASSERT_STREQ(expected, actual);     EXPECT_STREQ(expected, actual)
 *  ASSERT_STRNE(expected, actual);     EXPECT_STRNE(expected, actual)
 *  ASSERT_STRCASEEQ(expected, actual); EXPECT_STRCASEEQ(expected, actual)
 *  ASSERT_STRCASENE(expected, actual); EXPECT_STRCASENE(expected, actual)
 *
 *----------------------------------------------------------------------------*/

/*~-------------------------------------------------------------------------~-*
 * Formatting options for Emacs and vim.
 *
 * mode:c++
 * indent-tabs-mode:t
 * c-basic-offset:4
 * tab-width:4
 * vim: set tabstop=4 shiftwidth=4 expandtab :
 *~-------------------------------------------------------------------------~-*/
""")
