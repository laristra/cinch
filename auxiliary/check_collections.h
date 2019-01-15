#include <gtest/gtest.h>

namespace cinch {

////////////////////////////////////////////////////////////////////
//! \brief Perform by element comparison of two (left and right)
//!        collections.  
//!
//! Similar behaviour to BOOST_CHECK_EQUAL_COLLECTIONS.  This tool
//! shows all mismatched elements in a collections. Note though that
//! right collection may have extra elements. This is does not get
//! checked by this tool. You may need to check explicitly that
//! collections have the same size.
/////////////////////////////////////////////////////////////////////
template<typename LeftIter, typename RightIter>
::testing::AssertionResult CheckEqualCollections(
  LeftIter left_begin,
  LeftIter left_end,
  RightIter right_begin,
  RightIter right_end) 
{
  bool equal(true);
  std::stringstream message;
  std::size_t index(0);
  
  while (left_begin != left_end) 
  {
    // right file ends early
    if (right_begin == right_end) {
      equal = false;
      message << "\n\tRight file ends early after " << index << " lines";
      break;
    }
    // mismatch in files
    if (*left_begin++ != *right_begin++) {
      equal = false;
      message << "\n\tMismatch at index " << index;
      break;
    }
    ++index;
  }

  // left ends early 
  if (left_begin == left_end && right_begin != right_end && equal) {
    equal = false;
    message << "\n\tLeft file ends early after " << index << " lines";
  }
  
  if (!message.eof())
    message << "\n\t";
  return equal ? ::testing::AssertionSuccess() :
    ::testing::AssertionFailure() << message.str();
}

} // namepsace
