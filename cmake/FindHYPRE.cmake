# - Try to find HYPRE
#
find_package(PkgConfig)

pkg_check_modules(PC_HYPRE hypre)

find_path(HYPRE_INCLUDE_DIR HYPRE.h HINTS ${PC_HYPRE_INCLUDE_DIRS})

find_library(HYPRE_LIBRARY NAMES HYPRE ${PC_HYPRE_LIBRARIES} HINTS ${PC_HYPRE_LIBRARY_DIRS} )


set(HYPRE_LIBRARIES ${HYPRE_LIBRARY} ${HYPRE_LIBRARIES})
set(HYPRE_INCLUDE_DIRS ${HYPRE_INCLUDE_DIR})

if (NOT HYPRE_INCLUDE_DIR)

set(HYPRE_ROOT "/usr" CACHE PATH "Root directory of HYPRE installation")

find_path(HYPRE_CHECK_DIR HYPRE.h HINTS ${HYPRE_ROOT}/include)

if (NOT HYPRE_CHECK_DIR)

 message (WARNING " HYPRE package was not found in your system,
                   please set a correct  HYPRE_ROOT variable ")
else( NOT HYPRE_CHECK_DIR)

set(HYPRE_INCLUDE_DIRS "${HYPRE_ROOT}/include")
set(HYPRE_LIBRARIES "${HYPRE_ROOT}/lib/libHYPRE.a")
set (HYPRE_LIBRARY ${HYPRE_LIBRARIES})
set (HYPRE_FOUND ON)

endif (NOT HYPRE_CHECK_DIR)

endif(NOT HYPRE_INCLUDE_DIR)

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set LAPACKE_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(HYPRE DEFAULT_MSG  HYPRE_LIBRARIES HYPRE_INCLUDE_DIRS )

mark_as_advanced(HYPRE_INCLUDE_DIR HYPRE_LIBRARY HYPRE_CHECK_DIR)


