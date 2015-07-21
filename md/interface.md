<!-- CINCHDOC DOCUMENT(User Guide) CHAPTER(Interface) -->

# Cinch CMake Interface{#cmake-interface}

<!-- cinch_add_application_directory -->

## *cinch\_add\_application\_directory*(directory){#cinch-add-application-directory}

<!-- cinch_add_doc -->

## *cinch\_add\_doc*(target config directory output){#cinch-add-doc}

Add a documentation build target.

**target** - The build target label, i.e., a make target will be created
such that 'make target' can be called to generate the documentation target.

**config** - A configuration file that must live in the 'doc' subdirectory
of the top-level directory of your project.  This file should contain a
single python dictionary *opts* that sets the cinch command-line
interface options for your docuement.

**directory** - The *relative* path to the head of the
directory tree within which to search for markdown documentation files.

**output** - The name of the output file that should be produced by pandoc.

<!-- cinch_add_doxygen -->

## *cinch\_add\_doxygen*(){#cinch-add-doxygen}

Add Doxygen documentation.

Currently there are no arguements to this
function.  If this function is called, cinch will expect for there to
be a ***doxygen.conf.in*** file in the 'doc' subdirectory.  This configuration
file should set the following options:

    PROJECT_NAME = "@PROJECT_NAME@"
    PROJECT_NUMBER = ${${PROJECT_NAME}_VERSION}
    OUTPUT_DIRECTORY = @CMAKE_BINARY_DIR@/doc/${${PROJECT_NAME}_DOXYGEN_TARGET}

Other options may be set as desired to customize Doxygen's behavior.

<!-- cinch_add_library_target -->

## *cinch\_add\_library\_target*(target directory){#cinch-add-library-target}

Add a library target to the currently scoped cmake build.

**target** - The build target label, i.e., a make target will be created
such that 'make target' can be called to generate the library target.
This name will also be used for the library name, e.g., lib*name*.a.

**directory** - The *relative* path to the head of the
directory tree which contains the source code for the library.  This
directory must also contain a symbolic link to the 'cmake/SourceLists.txt'
file.  Optionally, this directory may also contain a file name
'library.cmake' that specifies customization of the target library.
Currently, this file can only be used to define public header files for the
target, i.e., target_PUBLIC_HEADERS.  This CMake variable should be set
at PARENT\_SCOPE to the list of public headers (with relative path) that
are to be added to the build and install steps.

<!-- cinch_add_subproject -->

## *cinch\_add\_subproject*(subproject){#cinch-add-subproject}

<!-- cinch_add_unit -->

## *cinch\_add\_unit*(target sources){#cinch-add-unit}

<!-- cinch_make_include_links -->

## *cinch\_make\_include\_links*(target src){#cinch-make-include-links}

<!-- cinch_make_info -->

## *cinch\_make\_info*(directory headers sources){#cinch-make-info}

<!-- cinch_make_version -->

## *cinch\_make\_version*(){#cinch-make-version}

Create a version number in the form *major.minor.build-hash* using 'git describe'.

The *major* and *minor* fields must be set using an annotated tag
('git tag -a -m "Annotation" *major.minor* object-name').  The
*build* field will be the number of commits from the creation of the most
recent annotated tag.  The *hash* field will be a partial hash that is the
abbreviated object name of the most recent commit.

If no annotated tag is set, this function will warn the user and create
a dummy version called 'dummy-0.0.0'.

<!-- cinch_prevent_insource_builds -->

## *cinch\_prevent\_insource\_builds*(){#cinch-prevent-insource-builds}

Prohibit users from creating in-place builds, i.e., builds that are
rooted in the top-level project directory of a cinch project.

If the user attempts to configure such a build, cmake will exit with
an error and issue instructions for how to clean up and create an
out-of-source build.

<!-- cinch_subdirlist -->

## *cinch\_subdirlist*(result directory){#cinch-subdirlist}

<!-- cinch_subfilelist -->

## *cinch\_subfilelist*(result directory){#cinch-subfilelist}
