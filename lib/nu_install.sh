#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.3b0 - lib/nu_install.sh - LICENSE: BSD_SMPL
#
# Copyright (c) 2008-2015 Chad Jacob Milios and Crop Circle Systems, Inc.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Simplified BSD License.
# If a copy of the Simplified BSD License was not distributed alongside this file, you can
# obtain one at http://www.freebsd.org/copyright/freebsd-license.html . This software
# project is not affiliated with the FreeBSD Project.
#
# Official updates and community support available at https://nuos.org .
# Other licensing options and professional services available at https://ccsys.com .

nuos_lib_ver=0.0.9.3b0
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -n "${nuos_lib_system_loaded-}" ]
[ -n "${nuos_lib_make_loaded-}" ]
[ -n "${nuos_lib_ports_loaded-}" ]
[ -n "${nuos_lib_collection_loaded-}" ]
[ -z "${nuos_lib_install_loaded-}" ]
nuos_lib_install_loaded=y

install_vars_init () {
	make_vars_init
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
	: ${HOST:=`hostname`}
	echo 'pool devs       -d POOL_DEVS      ' $POOL_DEVS
	echo 'pool name       -p POOL_NAME      ' ${POOL_NAME:=thumb}
	echo 'pool mnt pt     -m POOL_MNT       ' ${POOL_MNT:=/$POOL_NAME}
	echo 'pool type       -t POOL_TYPE      ' ${POOL_TYPE=raidz}
	echo 'pool options    -o POOL_OPTS      ' ${POOL_OPTS="-O atime=off -O compression=lz4"}
	echo 'pkg collection  -c PKG_COLLECTION ' $PKG_COLLECTION
	echo 'port db dir        PORT_DBDIR     ' $PORT_DBDIR
	echo 'swap size       -s SWAP_SIZE      ' ${SWAP_SIZE:=512M}
	echo 'new host name   -h NEW_HOST       ' ${NEW_HOST:=$POOL_NAME.${HOST#*.}}
	echo 'make jobs          MAKE_JOBS      ' ${MAKE_JOBS:=$((2+`sysctl -n kern.smp.cpus`))}
	echo 'target arch        TRGT_ARCH      ' $TRGT_ARCH
	echo 'target proc        TRGT_PROC      ' $TRGT_PROC
	echo 'target kern        TRGT_KERN      ' ${TRGT_KERN:=NUOS}
	echo 'target optimize    TRGT_OPTZ      ' $TRGT_OPTZ
	if [ -z "${SVN_SERVER-}" ]; then
		choose_random SVN_SERVER svn0.us-west.FreeBSD.org svn0.us-east.FreeBSD.org
	fi
	echo 'subversion server  SVN_SERVER     ' $SVN_SERVER
	echo 'subversion path    SVN_PATH       ' ${SVN_PATH:=base/releng/9.3}
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
		[ -d ~/.subversion ] || mkdir ~/.subversion
		[ -d ~/.subversion/auth ] || (umask 77 && mkdir ~/.subversion/auth)
		[ -d ~/.subversion/auth/svn.ssl.server ] || mkdir ~/.subversion/auth/svn.ssl.server
		local svn_server_lc=`echo $SVN_SERVER | tr '[:upper:]' '[:lower:]'`
		local svn_realm=https://$svn_server_lc:443
		local svn_realm_len=${#svn_realm}
		local svn_realm_hash=`echo -n $svn_realm | md5`
		local srv_pub_key=`eval echo '~/.subversion/auth/svn.ssl.server/$svn_realm_hash'`
		if [ ! -f $srv_pub_key ]; then
			cat > $srv_pub_key <<EOF
K 10
ascii_cert
V 2284
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
K 8
failures
V 1
8
K 15
svn:realmstring
V $svn_realm_len
$svn_realm
END
EOF
		fi
		
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

