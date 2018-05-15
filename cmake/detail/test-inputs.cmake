#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

    #--------------------------------------------------------------------------#
    # Process test inputs
    #--------------------------------------------------------------------------#

    if(test_INPUTS)

        set(_OUTPUT_FILES)

        foreach(input ${test_INPUTS})
            get_filename_component(_OUTPUT_NAME ${input} NAME)
            get_filename_component(_PATH ${input} ABSOLUTE)
            add_custom_command(OUTPUT ${_OUTPUT_DIR}/${_OUTPUT_NAME}
                COMMAND
                    ${CMAKE_COMMAND} -E copy ${_PATH}
                    ${_OUTPUT_DIR}/${_OUTPUT_NAME}
                DEPENDS ${input}
                COMMENT "Copying ${input} for ${name}"
            )
            list(APPEND _OUTPUT_FILES ${_OUTPUT_DIR}/${_OUTPUT_NAME})
        endforeach()

        add_custom_target(${name}_inputs DEPENDS ${_OUTPUT_FILES})
        add_dependencies(${name} ${name}_inputs)

        if(test_FOLDER)
            set_target_properties(${name}_inputs
                PROPERTIES FOLDER "${test_FOLDER}/Inputs")
        endif()

    endif()

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
