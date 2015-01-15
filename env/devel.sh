#~----------------------------------------------------------------------------~#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#~----------------------------------------------------------------------------~#

# Get the directory where the script is installed
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Add git directory to path
export PATH=$PATH:$script_dir/../git

# Add cli directory to path
export PATH=$PATH:$script_dir/../cli/bin

# Add cli directory to python path
export PYTHONPATH=$PYTHONPATH:$script_dir/../cli
