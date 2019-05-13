option(ENABLE_CUDA_RUNTIME)

if(ENABLE_CUDA_RUNTIME)
  find_package(CUDA)

  if(NOT CUDA_FOUND)
    message(FATAL_ERROR
      "The Cuda runtime libraries are required for this build configuration")
  endif()

  message(STATUS "Found Cuda Runtime: ${CUDA_SDK_ROOT_DIR}")

  include_directories(${CUDA_INCLUDE_DIRS})
  list(APPEND CINCH_RUNTIME_LIBRARIES ${CUDA_LIBRARIES})

endif()

macro(tag_cuda_sources)

  message(STATUS "\nTagging Cuda sources: ${ARGN}\n")

  foreach(source IN ITEMS ${ARGN})
    set_source_files_propoerties(${source} PROPERTIES LANGUAGE CXX)
  endforeach()

endmacro()
