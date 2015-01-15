#-----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#~----------------------------------------------------------------------------~#

# Get the directory where the script is installed
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

# Add git directory to path
setenv PATH ${PATH}:${script_dir}/../git

# Add cli directory to path
setenv PATH ${PATH}:${script_dir}/../cli/bin

# Add cli directory to path
setenv PYTHONPATH ${PYTHONPATH}:${script_dir}/../cli
