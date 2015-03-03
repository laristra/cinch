<!-- CINCHDOC DOCUMENT(User Guide) CHAPTER(Installation) -->

# Installation

Cinch uses standard CMake install features. However, because Cinch depends
on its own command-line tool (Cinch-Utils) to build its documentation,
it must be installed in stages.

## Install the Cinch-Utils Command-Line Tool

To begin, in the cinch-utils directory:

    % mkdir build
    % cd build
    % cmake -DCMAKE_INSTALL_PREFIX=/path/to/install ..
    % make install

This will install the command-line tool and some helper scripts to
setup your environment.  After you have performed the above step, you
should source the appropriate environment script, e.g.:

    % source /path/to/install/bin/cinchenv.sh (bash)

or

    % source /path/to/install/bin/cinchenv.csh (csh/tcsh)

The installation also includes an environment module that may be
used to configure your environment.  This may be installed in an
appropriate system location, or locally by adding the installation
bin directory to your MODULEPATH.

**If you prefer, you may also set the required environments variables
manually:**

***PATH*** add the bin directory of the install path to your PATH

***PYTHONPATH*** add the lib/python*X.X*/site-packages path to your PYTHONPATH

## Install Documentation

To install the Cinch documentation, you should run cmake in the Cinch
build directory with documentation enabled:

    % cmake -DCMAKE_INSTALL_PREFIX=/path/to/install -DENABLE_DOCUMENTATION=ON ..
    % make install
