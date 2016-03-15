#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import os
import re
import shutil
import getpass
import datetime
import subprocess
from templates import *
from ccli.services.service_utils import *

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def create_project(args):

    """
    """

    #--------------------------------------------------------------------------#
    # Create a new git project and add cinch submodule
    #--------------------------------------------------------------------------#

    print "Creating new git project " + args.name + "..."

    subprocess.call(["git", "init", "-q", args.name])
    os.chdir(args.name)
    subprocess.call(["git", "submodule", "add",
        "git@github.com:losalamos/cinch.git"])
    subprocess.call(["git", "submodule", "foreach",
        "git submodule init; git submodule update"])

    #--------------------------------------------------------------------------#
    # Create top-level directory structure
    #--------------------------------------------------------------------------#

    print "Creating directory structure..."

    os.mkdir("app")
    os.mkdir("config")
    os.mkdir("doc")
    os.mkdir("doc/doxygen")
    os.mkdir("doc/doxygen/images")
    os.mkdir("src")
    os.mkdir("src/example")
    os.mkdir("src/example/test")

    #--------------------------------------------------------------------------#
    # Copy configuration files into tree.
    #--------------------------------------------------------------------------#

    print "Copying configuration files..."

    shutil.copyfile("cinch/bootstrap/top-level.txt", "CMakeLists.txt")
    shutil.copyfile("cinch/bootstrap/src-level.txt", "src/CMakeLists.txt")
    shutil.copyfile("cinch/doxygen/doxygen.conf.in", "doc/doxygen.conf.in")

    #--------------------------------------------------------------------------#
    # Populate config sub-directory
    #--------------------------------------------------------------------------#

    print "Populating config subdirectory..."

    config_project = cinch_config_project.safe_substitute(
        PROJECT=args.name,
        TABSTOP=args.tabstop
    )
    fd = open("config/project.cmake", 'w')
    fd.write(config_project[1:-1])
    fd.close()

    config_packages = cinch_config_packages.safe_substitute(
        TABSTOP=args.tabstop
    )
    fd = open("config/packages.cmake", 'w')
    fd.write(config_packages[1:-1])
    fd.close()

    config_documentation = cinch_config_documentation.safe_substitute(
        TABSTOP=args.tabstop
    )
    fd = open("config/documentation.cmake", 'w')
    fd.write(config_documentation[1:-1])
    fd.close()

    #--------------------------------------------------------------------------#
    # Get the current user and date
    #--------------------------------------------------------------------------#

    author = getpass.getuser()
    date = datetime.datetime.now().strftime("%b %d, %Y")

    #--------------------------------------------------------------------------#
    # Populate example sub-directory
    #--------------------------------------------------------------------------#

    print "Populating example subdirectory..."

    example_cmake = cinch_example_cmake.safe_substitute(
        TABSTOP=args.tabstop
    )
    fd = open("src/example/CMakeLists.txt", 'w')
    fd.write(example_cmake[1:-1])
    fd.close()

    example_header = cinch_example_header.safe_substitute(
        AUTHOR=author,
        DATE=date,
        TABSTOP=args.tabstop
    )
    fd = open("src/example/utils.h", 'w')
    fd.write(example_header[1:-1])
    fd.close()

    example_source = cinch_example_source.safe_substitute(
        AUTHOR=author,
        DATE=date,
        TABSTOP=args.tabstop
    )
    fd = open("src/example/utils.cc", 'w')
    fd.write(example_source[1:-1])
    fd.close()

    example_unit = cinch_example_unit.safe_substitute(
        TABSTOP=args.tabstop
    )
    fd = open("src/example/test/unit.cc", 'w')
    fd.write(example_unit[1:-1])
    fd.close()

    example_md = cinch_example_md.safe_substitute(
        TABSTOP=args.tabstop
    )
    fd = open("src/example/utils.md", 'w')
    fd.write(example_md[1:-1])
    fd.close()

    #--------------------------------------------------------------------------#
    # Populate app sub-directory
    #--------------------------------------------------------------------------#

    print "Populating app subdirectory..."

    app_cmake = cinch_app_cmake.safe_substitute(
        TABSTOP=args.tabstop
    )
    fd = open("app/CMakeLists.txt", 'w')
    fd.write(app_cmake[1:-1])
    fd.close()

    app_source = cinch_app_source.safe_substitute(
        AUTHOR=author,
        DATE=date,
        TABSTOP=args.tabstop
    )
    fd = open("app/app.cc", 'w')
    fd.write(app_source[1:-1])
    fd.close()

    #--------------------------------------------------------------------------#
    # Populate doc sub-directory
    #--------------------------------------------------------------------------#

    print "Populating doc subdirectory..."

    doc_ug = cinch_doc_ug.safe_substitute(
        TABSTOP=args.tabstop
    )
    fd = open("doc/ugconfig.py", 'w')
    fd.write(doc_ug[1:-1])
    fd.close()

    doc_dg = cinch_doc_dg.safe_substitute(
        TABSTOP=args.tabstop
    )
    fd = open("doc/dgconfig.py", 'w')
    fd.write(doc_dg[1:-1])
    fd.close()

    doc_header = cinch_doc_header.safe_substitute(
        TABSTOP=args.tabstop
    )
    fd = open("doc/header.tex.in", 'w')
    fd.write(doc_header[1:-1])
    fd.close()

    #--------------------------------------------------------------------------#
    # README.md file
    #--------------------------------------------------------------------------#

    print "Create README.md..."

    readme = cinch_readme.safe_substitute(
        TABSTOP=args.tabstop
    )
    fd = open("README.md", 'w')
    fd.write(readme[1:-1])
    fd.close()


    #--------------------------------------------------------------------------#
    # Tag project for version creation
    #--------------------------------------------------------------------------#

    print "Adding files to local repository and tagging..."

    subprocess.call(["git", "add", "*"])
    subprocess.call(["git", "commit", "-m", "Initial Check-In"])
    master = subprocess.check_output(["git", "rev-parse", "HEAD"]).rstrip()
    subprocess.call(["git", "tag", "-a", "-m", "Initial Check-In",
        "0.0", master])

# create_project

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
