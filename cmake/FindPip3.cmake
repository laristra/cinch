find_program(PIP3_EXECUTABLE NAMES pip3
    HINTS
    $ENV{PIP3_DIR}
    PATH_SUFFIXES bin
    DOC "Pip 3 Python Package Manager"
)
 
include(FindPackageHandleStandardArgs)
 
find_package_handle_standard_args(pip3 DEFAULT_MSG
  PIP3_EXECUTABLE
)
 
mark_as_advanced(PIP3_EXECUTABLE)
