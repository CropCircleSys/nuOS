#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.0b0.1 - lib/nu_install.sh - LICENSE: BSD_SMPL
#
# Copyright (c) 2008-2017 Chad Jacob Milios and Crop Circle Systems, Inc.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Simplified BSD License.
# If a copy of the Simplified BSD License was not distributed alongside this file, you can
# obtain one at https://www.freebsd.org/copyright/freebsd-license.html . This software
# project is not affiliated with the FreeBSD Project.
#
# Official updates and community support available at https://nuos.org .
# Other licensing options and professional services available at https://ccsys.com .

nuos_lib_ver=0.0.11.0b0.1
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -n "${nuos_lib_system_loaded-}" ]
[ -n "${nuos_lib_make_loaded-}" ]
[ -n "${nuos_lib_ports_loaded-}" ]
[ -n "${nuos_lib_collection_loaded-}" ]
[ -z "${nuos_lib_install_loaded-}" ]
nuos_lib_install_loaded=y

install_vars_init () {
	if [ -z "${POOL_DEVS-}" ]; then # u shud spec a blank target media
		if [ -n "${OPT_SWAP-}" ]; then # or ask to use these in (-S)wap
			# have 2 - 8 GB of xtra ram depending on install options
			POOL_DEVS="`mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g` `mdconfig -s 1g`"
			# and hopefully your build is successful OR you CLEAN UP after yerself!
		else
			echo "`basename $0`: -d or -S must be specified" >&2
			exit 1
		fi
	fi
	: ${HOST:=`hostname`}
	echo 'pool devs       -d POOL_DEVS      ' $POOL_DEVS
	echo 'pool name       -p POOL_NAME      ' ${POOL_NAME:=thumb}
	echo 'pool mnt pt     -m POOL_MNT       ' ${POOL_MNT:=/$POOL_NAME}
	echo 'pool type       -t POOL_TYPE      ' ${POOL_TYPE=raidz}
	echo 'partition align    PART_ALIGN     ' ${PART_ALIGN:=128} # stripesize/sectorsize of eventual target media's presented device. power of two, err higher
	echo 'pool options    -o POOL_OPTS      ' ${POOL_OPTS="-O atime=off -O compression=lz4"}
	echo 'pkg collection  -c PKG_COLLECTION ' $PKG_COLLECTION
	echo 'port db dir        PORT_DBDIR     ' $PORT_DBDIR
	echo 'swap size       -s SWAP_SIZE      ' ${SWAP_SIZE:=1G}
	echo 'new host name   -h NEW_HOST       ' ${NEW_HOST:=$POOL_NAME.${HOST#*.}}
	echo 'make jobs          MAKE_JOBS      ' ${MAKE_JOBS:=$((2+`sysctl -n kern.smp.cpus`))}
	echo 'target arch        TRGT_ARCH      ' $TRGT_ARCH
	echo 'target proc        TRGT_PROC      ' $TRGT_PROC
	echo 'target kern        TRGT_KERN      ' ${TRGT_KERN:=NUOS}
	echo 'target optimize    TRGT_OPTZ      ' $TRGT_OPTZ
	echo 'subversion server  SVN_SERVER     ' ${SVN_SERVER=svn.FreeBSD.org}
	echo 'subversion path    SVN_PATH       ' ${SVN_PATH:=base/releng/11.0}
	echo -n 'copy ports         COPY_PORTS      ' && [ -n "${COPY_PORTS-}" ] && echo set || echo null
	echo -n 'copy all pkgs      COPY_DEV_PKGS   ' && [ -n "${COPY_DEV_PKGS-}" ] && echo set || echo null
	echo -n 'copy src           COPY_SRC        ' && [ -n "${COPY_SRC-}" ] && echo set || echo null
	echo -n 'copy svn repo      COPY_SVN        ' && [ -n "${COPY_SRC-}" ] && ([ -n "${COPY_SVN-}" ] && echo set || echo null) || echo n/a
}

require_subversion () {
	if which svn; then
	else
		sister nu_install_pkg devel/subversion
	fi
}

require_base_src () {
	if [ ! -f /usr/src/Makefile ]; then
		require_subversion
		
		local svn_errors=0
		svn checkout https://$SVN_SERVER/$SVN_PATH /usr/src || svn_errors=1

		local max_svn_errors=5
		while [ $svn_errors -gt 0 -a -z "${svn_success-}" -a $svn_errors -lt $max_svn_errors ]; do
			local svn_retry_pause=15
			echo suffered $svn_errors errors while checking out base system source code from subversion server at $SVN_SERVER
			echo pausing for at least $svn_retry_pause seconds
			(cd /usr/src && svn cleanup && sleep $svn_retry_pause && svn update) && svn_success=y || svn_errors=$(($svn_errors+1))
		done
		[ $svn_errors -lt $max_svn_errors ]

		baseos_init
	fi
	local make_conf retire_make_conf_cmd
	if [ ! -d /usr/obj/usr/src/bin ]; then
		prepare_make_conf make_conf retire_make_conf_cmd
		(cd /usr/src && make -j $MAKE_JOBS "__MAKE_CONF=$make_conf" buildworld)
		$retire_make_conf_cmd make_conf
	fi
	if [ ! -d /usr/obj/usr/src/sys/$TRGT_KERN ]; then
		if [ $TRGT_KERN = NUOS ] && [ ! -e /usr/src/sys/$TRGT_ARCH/conf/NUOS -o /usr/src/sys/$TRGT_ARCH/conf/NUOS -ot "$(realpath "$(dirname "$(realpath "$0")")/../share/kern/NUOS.tmpl")" ]; then
			if [ -e /usr/src/sys/$TRGT_ARCH/conf/VT ]; then
				kernel_prototype=VT
			else
				kernel_prototype=GENERIC
			fi
			sed -e s/%%nuos_kernel_prototype%%/$kernel_prototype/g "$(realpath "$(dirname "$(realpath "$0")")/../share/kern/NUOS.tmpl")" >| /usr/src/sys/$TRGT_ARCH/conf/NUOS
		fi
		prepare_make_conf make_conf retire_make_conf_cmd
		(cd /usr/src && make -j $MAKE_JOBS "__MAKE_CONF=$make_conf" KERNCONF=$TRGT_KERN buildkernel)
		$retire_make_conf_cmd make_conf
	fi
}

