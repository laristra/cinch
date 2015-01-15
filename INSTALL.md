<!-- CINCHDOC DOCUMENT(User Guide) CHAPTER(Installation) -->

# Installation

Cinch uses standard CMake install features. However, because Cinch depends
on its own command-line tool to build its documentation, it must be
installed in stages.

## Install Command-Line Tool

To begin, configure Cinch to install without documentation:

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

## Install Documentation

To install the Cinch documentation, you should rerun cmake with
documentation enabled:

    % cmake -DCMAKE_INSTALL_PREFIX=/path/to/install -DENABLE_DOCUMENTATION=ON ..
    % make install
