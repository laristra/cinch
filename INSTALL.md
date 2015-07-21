<!-- CINCHDOC DOCUMENT(User Guide) CHAPTER(Installation) -->

# Installation

Cinch uses standard CMake install features. However, because Cinch depends
on its own command-line tool (Cinch-Utils) to build its documentation,
it must be installed in stages.

## Install the Cinch-Utils Command-Line Tool

Directions for installing cinch-utils are [here](http://gitlab.lanl.gov/ngc-utils/cinch-utils#installation)

## Install Documentation

To install the Cinch documentation, you should run cmake in the Cinch
build directory with documentation enabled:

    % cmake -DCMAKE_INSTALL_PREFIX=/path/to/install -DENABLE_DOCUMENTATION=ON ..
    % make install
