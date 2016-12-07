/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

#include <gtest/gtest.h>
#include <mpi.h>

#include "listener.h"

int main(int argc, char ** argv) {

  int version, subversion;
  MPI_Get_version(&version, &subversion);
  std::cout <<"MPI version = "<< version<< " , subversion =" << subversion << std::endl;
//TOFIX:: add check for Gasnet conduit
  if(version==3 && subversion>0){
    int provided;
    MPI_Init_thread(&argc, &argv, MPI_THREAD_MULTIPLE, &provided);
    // If you fail this assertion, then your version of MPI
    // does not support calls from multiple threads and you 
    // cannot use the GASNet MPI conduit
    if (provided < MPI_THREAD_MULTIPLE)
      printf("ERROR: Your implementation of MPI does not support "
           "MPI_THREAD_MULTIPLE which is required for use of the "
           "GASNet MPI conduit with the Legion-MPI Interop!\n");
    assert(provided == MPI_THREAD_MULTIPLE);
  }
  else{
    // Initialize the MPI runtime
    MPI_Init(&argc, &argv);
  }
  // Initialize the GTest runtime
  ::testing::InitGoogleTest(&argc, argv);

  ::testing::TestEventListeners& listeners =
    ::testing::UnitTest::GetInstance()->listeners();

  // Adds a listener to the end.  Google Test takes the ownership.
  listeners.Append(new cinch::listener);

  int result = RUN_ALL_TESTS();

  // Shutdown the MPI runtime
  // GMS: HACK as we are racing with Legion/GASNet 
  //MPI_Finalize();

  return result;

} // main

/*~------------------------------------------------------------------------~--*
 * vim: set tabstop=2 shiftwidth=2 expandtab :
 *~------------------------------------------------------------------------~--*/
