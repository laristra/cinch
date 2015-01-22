#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

option(GASNET_ROOT "Root directory of GASNet installation" OFF)
option(GASNET_CONDUIT "GASNet conduit to use" OFF)

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

find_path(GASNET_INCLUDE_DIR gasnet.h
    HINTS ENV GASNET_ROOT
    PATHS ${GASNET_ROOT}
    PATH_SUFFIXES include)

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

set(GASNET_LIBRARY_FOUND False)

if(NOT GASNET_CONDUIT)
    foreach(conduit aries gemini ibv mpi mxm pami portals4 shmem smp udp)
        foreach(model seq parsync par)
            find_library(GASNET_${conduit}_${model} gasnet-${conduit}-${model}
                HINTS ENV GASNET_ROOT
                PATHS ${GASNET_ROOT}
                PATH_SUFFIXES lib lib64)

            if(GASNET_${conduit}_${model})
                if(NOT GASNET_LIBRARY_FOUND)
                    set(GASNET_LIBRARY_FOUND ${GASNET_${conduit}_${model}})
                endif()
            endif()
        endforeach(model)
    endforeach(conduit)
else()
    find_library(GASNET_${GASNET_CONDUIT} gasnet-${GASNET_CONDUIT}
        HINTS ENV GASNET_ROOT
        PATHS ${GASNET_ROOT}
        PATH_SUFFIXES lib lib64)

    if(GASNET_${GASNET_CONDUIT})
        set(GASNET_LIBRARY_FOUND ${GASNET_${GASNET_CONDUIT}})
    endif()
endif(NOT GASNET_CONDUIT)

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GASNET
    REQUIRED_VARS GASNET_LIBRARY_FOUND GASNET_INCLUDE_DIR)

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
