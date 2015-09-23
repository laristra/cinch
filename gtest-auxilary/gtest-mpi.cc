/*~-------------------------------------------------------------------------~~*
 * Copyright (c) 2014 Los Alamos National Security, LLC
 * All rights reserved.
 *~-------------------------------------------------------------------------~~*/

#include <gtest/gtest.h>
#include <mpi.h>

int main(int argc, char ** argv) {
	
	// Initialize the MPI runtime
	MPI_Init(&argc, &argv);

	// Initialize the GTest runtime
	::testing::InitGoogleTest(&argc, argv);
	int result = RUN_ALL_TESTS();

	// Shutdown the MPI runtime
	MPI_Finalize();

	return result;

} // main
