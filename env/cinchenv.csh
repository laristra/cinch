#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

# Get the directory where the script is installed
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

# Add git directory to path
setenv PATH ${PATH}:${script_dir}/../git

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
