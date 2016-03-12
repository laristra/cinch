#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import os
import re
import subprocess
from ccli.services.service_utils import *
from ccli.services.git_drivers.utils import *

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def process(args):

    """
    """

    #--------------------------------------------------------------------------#
    # Read the configuration file
    #--------------------------------------------------------------------------#

    with open(args.config) as fd:
        config = json.load(fd, object_pairs_hook=OrderedDict)

    # Iterate over the JSON entries.
    for item in config:

        # Print which operation the item is doing
        if(args.debug or args.verbose):
            print "Executing operation:", item["operation"]
            
        # Handle directories if necessary
        if("directory" in item):
            # Use the directory specified by the user.
            directory = item["directory"]
        else:
            # Create a temporary directory if the user hasn't specified one.
            directory = tempfile.mkdtemp()

            if(args.debug or args.verbose):
                print "Created temporary directory:", directory
            # if
        # if

        # Create clone mirror if we are mirroring or cloning
        if(item["operation"] == "mirror" or item["operation"] == "clone"):
            clone_mirror(item["src"], directory, args)
        # if

        # Push the mirror if we are mirroring or pushing
        if(item["operation"] == "mirror" or item["operation"] == "push"):
            push_mirror(item["dest"], directory, args)
        # if

        # Create an archive
        if(item["operation"] == "archive"):
            create_archive(item["src"], directory, item["filename"], args)
        # if

        # Expand an archive
        if(item["operation"] == "expand"):
            expand_archive(directory, item["filename"], args)
        # if

        # Push an archive to the red network
        if(item["operation"] == "transfer"):
            transfer_file(directory, item["filename"])
        # if

        # Clean up if we created a temporary
        if(not args.debug and not "directory" in item):
            shutil.rmtree(directory)

            if(args.debug or args.verbose):
                print "Removed temporary directory: ", directory
            # if
        # if

        # New line for output
        if(args.debug or args.verbose):
            print "\n"
        # if

    # for

# process

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
