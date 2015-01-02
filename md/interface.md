<!-- CINCHDOC DOCUMENT(User Guide) CHAPTER(Interface) -->

# Cinch CMake Interface

## *cinch\_add\_doc*(target config directory output)

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

## *cinch\_add\_unit*(target sources)

## *cinch\_make\_info*(directory headers sources)

## *cinch\_prevent\_insource\_builds*()

## *cinch\_subdirlist*(result directory)

## *cinch\_subfilelist*(result directory)
