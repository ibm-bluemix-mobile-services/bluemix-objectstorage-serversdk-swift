#!/bin/bash

##
# Copyright IBM Corporation 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##

# This script builds the Kitura sample app on Travis CI.
# If running on the OS X platform, homebrew (http://brew.sh/) must be installed
# for this script to work.

# If any commands fail, we want the shell script to exit immediately.
set -e

# Swift version for build
export SWIFT_SNAPSHOT=swift-DEVELOPMENT-SNAPSHOT-2016-03-24-a
echo ">> SWIFT_SNAPSHOT: $SWIFT_SNAPSHOT"
export WORK_DIR=/root

# Utility functions
function sourceScript () {
  if [ -e "$1" ]; then
  	source "$1"
    echo "$2"
  fi
}

# Determine platform/OS
echo ">> uname: $(uname)"
if [ "$(uname)" == "Darwin" ]; then
  osName="osx"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  osName="linux"
else
  echo ">> Unsupported platform!"
  exit 1
fi
echo ">> osName: $osName"

# Make the working directory the parent folder of this script
cd "$(dirname "$0")"

# Get project name from project folder
export projectFolder=`pwd`
projectName="$(basename $projectFolder)"
echo ">> projectName: $projectName"
echo

# Install Swift binaries
source ${projectFolder}/${osName}/install_swift_binaries.sh

# Show path
echo ">> PATH: $PATH"

# Run SwiftLint to ensure Swift style and conventions
# swiftlint

# Build swift package from makefile
echo ">> Running makefile..."
cd ${projectFolder} && make
echo ">> Finished running makefile"

