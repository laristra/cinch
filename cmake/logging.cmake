#--------------------------------------------------------------------------#
# Add clog logging
#--------------------------------------------------------------------------#

include_directories(${CINCH_SOURCE_DIR}/logging)

#--------------------------------------------------------------------------#
# Install cinch logging utility
#--------------------------------------------------------------------------#

install(FILES ${CMAKE_SOURCE_DIR}/cinch/logging/cinchlog.h
    DESTINATION include)


# Add an option to set the strip level
set(CLOG_STRIP_LEVEL "0" CACHE STRING "Set the clog strip level")
add_definitions(-DCLOG_STRIP_LEVEL=${CLOG_STRIP_LEVEL})

# Allow color output
option(CLOG_COLOR_OUTPUT "Enable colorized clog logging" ON)
if(CLOG_COLOR_OUTPUT)
    add_definitions(-DCLOG_COLOR_OUTPUT)
endif()

# Enable tag groups
option(CLOG_ENABLE_TAGS "Enable tag groups" OFF)
if(CLOG_ENABLE_TAGS)
    set(CLOG_TAG_BITS "16" CACHE STRING
        "Select the number of bits to use for tag groups")
    add_definitions(-DCLOG_ENABLE_TAGS)
    add_definitions(-DCLOG_TAG_BITS=${CLOG_TAG_BITS})
endif()

# Externally scoped messages
option(CLOG_ENABLE_EXTERNAL
    "Enable messages that are defined at external scope" OFF)
if(CLOG_ENABLE_EXTERNAL)
    add_definitions(-DCLOG_ENABLE_EXTERNAL)
endif()

# MPI
if(MPI_${MPI_LANGUAGE}_FOUND)
    option(CLOG_ENABLE_MPI "Enable clog MPI functions" OFF)
    if(CLOG_ENABLE_MPI)
        add_definitions(-DCLOG_ENABLE_MPI)
    endif()

    set(CLOG_TURNSTILE_NWAY "1" CACHE STRING
        "Set the turnstile rotation for MPI messages")
    add_definitions(-DCLOG_TURNSTILE_NWAY=${CLOG_TURNSTILE_NWAY})
endif()

# Enable debugging
option(CLOG_DEBUG "Enable clog debugging" OFF)
if(CLOG_DEBUG)
    add_definitions(-DCLOG_DEBUG)
endif()


