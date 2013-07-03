#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.1a3 - lib/nu_install.sh - LICENSE: MOZ_PUB
#
# Copyright (c) 2008-2013 Chad Jacob Milios and Crop Circle Systems, Inc.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Mozilla Public License, v2.0.
# If a copy of the MPL was not distributed alongside this file, you can obtain one at
# http://mozilla.org/MPL/2.0/ . This software project is not affiliated with the Mozilla
# Foundation.
#
# Official updates and community support available at http://nuos.org .
# Other licensing options and professional services available at http://ccsys.com .

nuos_lib_ver=0.0.9.1a3
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -n "${nuos_lib_common_loaded-}" ]
[ -z "${nuos_lib_install_loaded-}" ]
nuos_lib_install_loaded=y

install_vars_init () {
	if [ -z "${POOL_DEVS-}" ]; then # u shud spec a blank target media
		if [ -n "${OPT_SWAP-}" ]; then # or ask to use these in (-S)wap
			# have 2 - 8 GB of xtra ram depending on install options
			POOL_DEVS="`mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g`"
			# and hopefully your build is successful OR you CLEAN UP after yerself!
			# this is a gud test that yer build will fit in a retail 8GB stick
		else
			echo "`basename $0`: -d or -S must be specified" >&2
			exit 1
		fi
	fi
	echo 'pool devs       -d POOL_DEVS      ' $POOL_DEVS
	echo 'pool mnt pt     -m POOL_MNT       ' ${POOL_MNT:=/$POOL_NAME}
	echo 'pool type       -t POOL_TYPE      ' ${POOL_TYPE=raidz}
	echo 'pool options    -o POOL_OPTS      ' ${POOL_OPTS="-O atime=off -O compression=on"}
	echo 'swap size       -s SWAP_SIZE      ' ${SWAP_SIZE:=512M}
	echo 'new host name   -h NEW_HOST       ' ${NEW_HOST:=$POOL_NAME.`hostname | sed -e 's/^[^\.]*\.//'`}
	echo 'target arch        TRGT_ARCH      ' ${TRGT_ARCH:=`uname -m`}
	echo 'target arch        TRGT_PROC      ' ${TRGT_PROC:=`uname -p`}
	echo -n 'copy ports         COPY_PORTS      ' && [ -n "${COPY_PORTS-}" ] && echo set || echo null
	echo -n 'copy port opts     COPY_PORT_OPTS  ' && [ -n "${COPY_PORT_OPTS-}" ] && echo set || echo null
	echo -n 'copy all pkgs      COPY_DEV_PKGS   ' && [ -n "${COPY_DEV_PKGS-}" ] && echo set || echo null
	echo -n 'copy src           COPY_SRC        ' && [ -n "${COPY_SRC-}" ] && echo set || echo null
	echo -n 'copy svn repo      COPY_SVN        ' && [ -n "${COPY_SRC-}" ] && ([ -n "${COPY_SVN-}" ] && echo set || echo null) || echo n/a
}
