<!-- CINCHDOC DOCUMENT(User Guide) CHAPTER(Installation) -->

# Installation

To install the Cinch command-line tool,
use the python setup utility by calling:

% python setup.py install

This should be done from the cli subdirectory.

Optionally, you can specify that the install should be local
(for users who do not have root privileges):

% python setup.py install --user

This will install the package in the user site-packages, which varies
depending on the operating system:

* **OS X**

    /Users/username/Library/Python/*version*/lib/python/site-packages

* **Linux**

    /home/username/.local/Python/*version*/lib/python/site-packages

**You must add the local Python bin directory to your PATH!!**

For more documentation on python setup:

% python setup.py --help
