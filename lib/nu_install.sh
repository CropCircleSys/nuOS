#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.2a1 - lib/nu_install.sh - LICENSE: MOZ_PUB
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

nuos_lib_ver=0.0.9.2a1
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -n "${nuos_lib_system_loaded-}" ]
[ -z "${nuos_lib_install_loaded-}" ]
nuos_lib_install_loaded=y

install_lite_vars_init () {
	: ${TRGT_OPTZ:=core2}
}

install_vars_init () {
	install_lite_vars_init
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
	echo 'pool name       -p POOL_NAME      ' ${POOL_NAME:=thumb}
	echo 'pool mnt pt     -m POOL_MNT       ' ${POOL_MNT:=/$POOL_NAME}
	echo 'pool type       -t POOL_TYPE      ' ${POOL_TYPE=raidz}
	echo 'pool options    -o POOL_OPTS      ' ${POOL_OPTS="-O atime=off -O compression=lz4"}
	echo 'pkg collection  -c PKG_COLLECTION ' ${PKG_COLLECTION:=desktop}
	echo 'swap size       -s SWAP_SIZE      ' ${SWAP_SIZE:=512M}
	echo 'new host name   -h NEW_HOST       ' ${NEW_HOST:=$POOL_NAME.`hostname | sed -e 's/^[^\.]*\.//'`}
	echo 'target arch        TRGT_ARCH      ' ${TRGT_ARCH:=`uname -m`}
	echo 'target arch        TRGT_PROC      ' ${TRGT_PROC:=`uname -p`}
	echo 'target kern        TRGT_KERN      ' ${TRGT_KERN:=VIMAGE}
	echo 'target optimize    TRGT_OPTZ      ' $TRGT_OPTZ
	echo -n 'copy ports         COPY_PORTS      ' && [ -n "${COPY_PORTS-}" ] && echo set || echo null
	echo -n 'copy port opts     COPY_PORT_OPTS  ' && [ -n "${COPY_PORT_OPTS-}" ] && echo set || echo null
	echo -n 'copy all pkgs      COPY_DEV_PKGS   ' && [ -n "${COPY_DEV_PKGS-}" ] && echo set || echo null
	echo -n 'copy src           COPY_SRC        ' && [ -n "${COPY_SRC-}" ] && echo set || echo null
	echo -n 'copy svn repo      COPY_SVN        ' && [ -n "${COPY_SRC-}" ] && ([ -n "${COPY_SVN-}" ] && echo set || echo null) || echo n/a
}

require_portsnap_files () {
	if [ ! -d /var/db/portsnap/files ]; then
		portsnap fetch
	fi
}

require_ports_tree () {
	if [ ! -f /usr/ports/Mk/bsd.port.mk ]; then
		require_portsnap_files
		portsnap extract
	fi
	if [ ! -d /usr/ports/packages ]; then
		mkdir /usr/ports/packages
	fi
}

prepare_make_conf () {
	if [ -i = $1 ]; then
		shift
		local opt_init=y
	fi
	if [ -z "${opt_init-}" ] && [ -s "${CHROOTDIR-}/etc/make.conf" ]; then
		setvar $1 "${CHROOTDIR-}/etc/make.conf"
		setvar $2 :
	else
		install_lite_vars_init
		local tempfile=`mktemp -t $(basename "$0").$$`
		cat >| $tempfile <<EOF
CPUTYPE?=$TRGT_OPTZ
WITH_BDB_VER=48
RUBY_DEFAULT_VER=1.9
PERL_VERSION=5.16.3
EOF
		setvar $1 $tempfile
		setvar $2 rm
	fi
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
		local srv_pub_key=`eval echo '~/.subversion/auth/svn.ssl.server/87ff8e8fd0384311d1630a5693b2abb5'`
		if [ ! -f $srv_pub_key ]; then
			cat > $srv_pub_key <<'EOF'
K 10
ascii_cert
V 2216
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
K 8
failures
V 2
12
K 15
svn:realmstring
V 36
https://svn0.us-east.freebsd.org:443
END
EOF
		fi
		svn checkout https://svn0.us-east.FreeBSD.org/base/releng/9.2 /usr/src
		baseos_init
	fi
	local make_conf cmd_to_retire_make_conf
	if [ ! -d /usr/obj/usr/src/bin ]; then
		prepare_make_conf make_conf cmd_to_retire_make_conf
		(cd /usr/src && make __MAKE_CONF=$make_conf buildworld)
		$cmd_to_retire_make_conf $make_conf
	fi
	if [ ! -d /usr/obj/usr/src/sys/$TRGT_KERN ]; then
		local kern_conf=/usr/src/sys/$TRGT_ARCH/conf/$TRGT_KERN
		if [ ! -f $kern_conf -a $TRGT_KERN = VIMAGE ]; then
			cat > $kern_conf <<EOF
include GENERIC
ident VIMAGE
options VIMAGE
EOF
		fi
		prepare_make_conf make_conf cmd_to_retire_make_conf
		(cd /usr/src && make __MAKE_CONF=$make_conf KERNCONF=$TRGT_KERN buildkernel)
		$cmd_to_retire_make_conf $make_conf
	fi
}

