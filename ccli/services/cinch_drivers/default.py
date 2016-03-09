#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import os
import re
import getpass
import datetime
import shutil
from sh import git
from sh import cd
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

    git.init(args.name)
    cd(args.name)
    git.submodule.add("git@github.com:losalamos/cinch.git")
    git.submodule.foreach("git submodule init; git submodule update");

    #--------------------------------------------------------------------------#
    # Create top-level directory structure
    #--------------------------------------------------------------------------#

    os.mkdir("app")
    os.mkdir("config")
    os.mkdir("doc")
    os.mkdir("doc/doxygen")
    os.mkdir("doc/doxygen/images")
    os.mkdir("src")
    os.mkdir("src/example")
    os.mkdir("src/example/test")

    #--------------------------------------------------------------------------#
    # Make symobolic links
    #--------------------------------------------------------------------------#

    os.symlink("cinch/cmake/ProjectLists.txt", "CMakeLists.txt")
    os.symlink("../cinch/cmake/SourceLists.txt", "src/CMakeLists.txt")
    os.symlink("../cinch/doxygen/doxygen.conf.in", "doc/doxygen.conf.in")

    #--------------------------------------------------------------------------#
    # Populate config sub-directory
    #--------------------------------------------------------------------------#

    config_project = cinch_config_project.substitute(
        PROJECT=args.name,
        TABSTOP=args.tabstop
    )
    fd = open("config/project.cmake", 'w')
    fd.write(config_project[1:-1])
    fd.close()

    config_packages = cinch_config_packages.substitute(
        TABSTOP=args.tabstop
    )
    fd = open("config/packages.cmake", 'w')
    fd.write(config_packages[1:-1])
    fd.close()

    config_documentation = cinch_config_documentation.substitute(
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

    example_cmake = cinch_example_cmake.substitute(
        TABSTOP=args.tabstop
    )
    fd = open("src/example/CMakeLists.txt", 'w')
    fd.write(example_cmake[1:-1])
    fd.close()

    example_header = cinch_example_header.substitute(
        AUTHOR=author,
        DATE=date,
        TABSTOP=args.tabstop
    )
    fd = open("src/example/utils.h", 'w')
    fd.write(example_header[1:-1])
    fd.close()

    example_source = cinch_example_source.substitute(
        AUTHOR=author,
        DATE=date,
        TABSTOP=args.tabstop
    )
    fd = open("src/example/utils.cc", 'w')
    fd.write(example_source[1:-1])
    fd.close()

    example_unit = cinch_example_unit.substitute(
        TABSTOP=args.tabstop
    )
    fd = open("src/example/test/unit.cc", 'w')
    fd.write(example_unit[1:-1])
    fd.close()

    example_md = cinch_example_md.substitute(
        TABSTOP=args.tabstop
    )
    fd = open("src/example/utils.md", 'w')
    fd.write(example_md[1:-1])
    fd.close()

    #--------------------------------------------------------------------------#
    # Populate app sub-directory
    #--------------------------------------------------------------------------#

    app_cmake = cinch_app_cmake.substitute(
        TABSTOP=args.tabstop
    )
    fd = open("app/CMakeLists.txt", 'w')
    fd.write(app_cmake[1:-1])
    fd.close()

    app_source = cinch_app_source.substitute(
        AUTHOR=author,
        DATE=date,
        TABSTOP=args.tabstop
    )
    fd = open("app/app.cc", 'w')
    fd.write(app_source[1:-1])
    fd.close()

    #--------------------------------------------------------------------------#
    # Tag project for version creation
    #--------------------------------------------------------------------------#

    git.add("*")
    git.commit("-m", "Initial Check-In")
    master = git("rev-parse", "HEAD").rstrip()
    git.tag("-a", "-m", "Initial Check-In", "0.0", master)

# create_project

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
