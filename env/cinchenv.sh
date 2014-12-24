#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# Get the directory where the script is installed
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Add git directory to path
export PATH=$PATH:$script_dir/../git

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
