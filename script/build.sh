#!/bin/bash
#====================================
# @file   : build.sh
# @brief  : build VegaStrike
# @usage  : ./script/build.sh
# @param  : none
#====================================
# Copyright (C) 2020-2021 Benjamen Meyer, Stephen G. Tuggy,
# and other Vega Strike contributors
#
# This file is part of Vega Strike.
#
# Vega Strike is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Vega Strike is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Vega Strike.  If not, see <https://www.gnu.org/licenses/>.
#============ DESCRIPTION ===========
# This script is making a clean build of VegaStrike.
# After this, it copies the relevant files to the 'bin' directory.
# The steps for creating this script were taken from the projects wiki:
# https://github.com/Taose/Vegastrike-taose/wiki/How-to-Build
#====================================


set -e

echo "-----------------------------"
echo "--- build.sh | 2021-12-30 ---"
echo "-----------------------------"

#----------------------------------
# validate parameters
#----------------------------------

ROOT_DIR=$(pwd)
BUILD_DIR="${ROOT_DIR}/build"
BIN_DIR="${ROOT_DIR}/bin"
SRC_DIR="${ROOT_DIR}/engine"
COMMAND=""

echo "ROOT_DIR: ${ROOT_DIR}"
echo "BUILD_DIR: ${BUILD_DIR}"

# -p creates if the target doesn't exist, noop otherwise
mkdir -pv "${BUILD_DIR}" && cd "${BUILD_DIR}"

# configure libraries and prepare for the Debug build having -Werror set,
# thus gating VS commits on being warning-free at some point in the near
# future -- see https://github.com/vegastrike/Vega-Strike-Engine-Source/issues/50
cmake $@ "${SRC_DIR}"

# for a clean build only
# mut we can do it manually
#make clean

# compile now using all cpus and show compilation commands
# MAX_THREADS_TO_BUILD_WITH=8
NUM_THREADS_TO_BUILD_WITH=$(getconf _NPROCESSORS_ONLN)
# if [ ${NUM_THREADS_TO_BUILD_WITH} -gt ${MAX_THREADS_TO_BUILD_WITH} ]
# then
#     NUM_THREADS_TO_BUILD_WITH=${MAX_THREADS_TO_BUILD_WITH}
# fi

VERBOSE=1 cmake --build "${BUILD_DIR}" -j $NUM_THREADS_TO_BUILD_WITH

cd "${ROOT_DIR}"

mkdir -pv "${BIN_DIR}"

cp -v "${BUILD_DIR}"/{vegastrike-engine,setup/vegasettings,objconv/vega-meshtool} "${BIN_DIR}"
