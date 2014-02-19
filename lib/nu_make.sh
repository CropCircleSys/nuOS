#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.2b2 - lib/nu_make.sh - LICENSE: BSD_SMPL
#
# Copyright (c) 2008-2014 Chad Jacob Milios and Crop Circle Systems, Inc.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Simplified BSD License.
# If a copy of the Simplified BSD License was not distributed alongside this file, you can
# obtain one at http://www.freebsd.org/copyright/freebsd-license.html . This software
# project is not affiliated with the FreeBSD Project.
#
# Official updates and community support available at http://nuos.org .
# Other licensing options and professional services available at http://ccsys.com .

nuos_lib_ver=0.0.9.2b2
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -n "${nuos_lib_system_loaded-}" ]
[ -z "${nuos_lib_make_loaded-}" ]
nuos_lib_make_loaded=y

make_vars_init () {
	: ${TRGT_PROC:=`uname -p`}
	case $TRGT_PROC in
		amd64) : ${TRGT_OPTZ:=core2};;
		i386) : ${TRGT_OPTZ:=pentium3};;
		*) [ -n "${TRGT_OPTZ-}" ]
	esac
}

prepare_make_conf () {
	local opt_init=
	while getopts i OPT; do case $OPT in
		i) opt_init=y;;
	esac; done; shift $(($OPTIND-1))
	
	local ret_file_var=$1; shift
	local ret_cmd_var=$1; shift
	
	if [ -z "$opt_init" ] && [ -s "${CHROOTDIR-}/etc/make.conf" ]; then
		setvar $ret_file_var "${CHROOTDIR-}/etc/make.conf"
		setvar $ret_cmd_var :
	else
		make_vars_init
		local tempfile=
		require_tmp tempfile
		cat >| "$tempfile" <<EOF
CPUTYPE?=$TRGT_OPTZ
NO_WARNING_PKG_INSTALL_EOL=yes
DEFAULT_VERSIONS= perl5=5.18 php=55
APACHE_PORT=www/apache24
WITH_BDB_VER=48
WITH_PGSQL_VER=92
WITH_MYSQL_VER=56
WITH_NEW_XORG=yes
EOF
		setvar $ret_file_var "$tempfile"
		setvar $ret_cmd_var retire_tmp
	fi
}
