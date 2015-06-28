#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.3b0 - lib/nu_ports.sh - LICENSE: BSD_SMPL
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

nuos_lib_ver=0.0.9.3b0
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -n "${nuos_lib_system_loaded-}" ]
[ -n "${nuos_lib_make_loaded-}" ]
[ -z "${nuos_lib_ports_loaded-}" ]
nuos_lib_ports_loaded=y

if [ -n "${PORT_DBDIR-}" ]; then
	_nuos_ports_dbdir_user_override=y
	exit 45
else
	PORT_DBDIR="$(realpath "$(dirname "$(realpath "$0")")/../port_opts")"
fi

# 
# prepare_ports_db () {
# 	if [ -n "${_nuos_ports_db_dir_poke-}" -a "${CHROOTDIR-}" ]; then
# 		require_tmp -c -C "$CHROOTDIR" -d _nuos_ports_db_dir_mnt
# 		mount -t nullfs -r $PORT_DBDIR "$_nuos_ports_db_dir_mnt"
# 	fi
# }
# 
# discard_ports_db () {
# 	if [ -n "${_nuos_ports_db_dir_poke-}" -a "${CHROOTDIR-}" ]; then
# 		umount "$_nuos_ports_db_dir_mnt"
# 		retire_tmp _nuos_ports_db_dir_mnt
# 	fi
# }

if [ -d /usr/ports/.svn ]; then
	_nu_PORTS_SVN=y
elif [ -f /var/db/portsnap/tag ]; then
	_nu_PORTSNAP=y
fi

if [ -d "${CHROOTDIR-}/var/db/nuos/pkg" -a ! -L "${CHROOTDIR-}/var/db/nuos/pkg" -a -f "${CHROOTDIR-}/var/db/nuos/pkg/tag" ]; then
	_nu_PORTS_TAG=`cat "${CHROOTDIR-}/var/db/nuos/pkg/tag"`
fi

require_portsnap_files () {
	if [ ! -d /var/db/portsnap/files ]; then
		portsnap fetch
	fi
}

require_ports_tree () {
	local opt_must_already_exist=
	while getopts e OPT; do case $OPT in
		e) opt_must_already_exist=y;;
	esac; done; shift $(($OPTIND-1))
	
	if [ ! -f /usr/ports/Mk/bsd.port.mk ]; then
		[ -z "$opt_must_already_exist" ]
		require_portsnap_files
		portsnap extract
	fi
	if [ ! -d /usr/ports/packages ]; then
		mkdir /usr/ports/packages
	fi
	if [ ! -d /usr/ports/packages/All ]; then
		mkdir /usr/ports/packages/All
	fi
	local pkg_meta="$(dirname "$(realpath "$0")")/../pkg"
	local port_shars="`cd "$pkg_meta" && ls *.shar 2> /dev/null`"
	for port_shar in $port_shars; do
		local port=`echo $port_shar | sed -e 's|_|/|;s/\.shar$//'`
		if [ ! -e /usr/ports/$port ]; then
			local category=${port%/*}
			(cd /usr/ports/$category && sh "$pkg_meta"/$port_shar)
		fi
	done
	local port_diffs="`cd "$pkg_meta" && ls *.diff 2> /dev/null`"
	for port_diff in $port_diffs; do
		local port=`echo $port_diff | sed -e 's|_|/|;s/\.diff$//'`
		local category=${port%/*}
		if [ -e "$pkg_meta"/$port_diff.test ]; then
			if (. "$pkg_meta"/$port_diff.test); then
				patch -C -F 0 -E -t -N -d /usr/ports/$port -i "$pkg_meta"/$port_diff > /dev/null 2>&1
				patch -F 0 -E -t -N -d /usr/ports/$port -i "$pkg_meta"/$port_diff
			fi
		elif patch -C -F 0 -E -t -N -d /usr/ports/$port -i "$pkg_meta"/$port_diff > /dev/null 2>&1; then
			patch -F 0 -E -t -N -d /usr/ports/$port -i "$pkg_meta"/$port_diff
		else
			echo
			echo '***' WARNING: Patch $port_diff did not apply cleanly. ASSUMING ports tree already contains up-to-date changes. '***'
			echo Sleeping 30 seconds...
			sleep 30
		fi
	done
}

pkg_name () {
	local opt_db= opt_installed=
	while getopts di OPT; do case $OPT in
		d) opt_db=y;;
		i) opt_installed=y;;
	esac; done; shift $(($OPTIND-1))
	
	local port=$1; shift
	
	[ $# = 0 ]
	
	if [ -n "$opt_db" ]; then
		cat "${CHROOTDIR-}/var/db/nuos/pkg/`echo $port | tr / _`/name"
	elif [ -n "$opt_installed" ]; then
		exit 78
		${CHROOTDIR:+chroot "$CHROOTDIR"} pkg_info -qO $port
	else
		local make_conf= retire_make_conf_cmd=
		prepare_make_conf make_conf retire_make_conf_cmd
		(cd /usr/ports/$port && make "__MAKE_CONF=$make_conf" PORT_DBDIR="$PORT_DBDIR" -VPKGNAME)
		$retire_make_conf_cmd make_conf
	fi
}

pkg_orgn () {
	local opt_installed=
	while getopts i OPT; do case $OPT in
		i) opt_installed=y;;
	esac; done; shift $(($OPTIND-1))
	
	local pkg=$1; shift
	
	[ $# = 0 ]
	
	if [ -n "$opt_installed" ]; then
		exit 78
		${CHROOTDIR:+chroot "$CHROOTDIR"} pkg_info -qo $pkg
	else
		(cd /usr/ports && make search name=$pkg | sed -nEe "/^Port:[[:blank:]]*$pkg\$/{N;s|^.*\nPath:[[:blank:]]*/usr/ports/(.*)\$|\1|;p;}")
	fi
}

port_deps () {
	for new in def opt build run; do
		eval local ret_${new}_var=\$1; shift
		if eval [ \"\$ret_${new}_var\" != _ ]; then
			eval local ret_${new}_tmp=
			eval require_tmp -l \$ret_${new}_var ret_${new}_tmp
		fi
	done
	local port=$1; shift
	
	[ $# = 0 ]
	
	local port_dir=/usr/ports/$port
	[ -d $port_dir ]
	
	local make_conf= retire_make_conf_cmd=
	prepare_make_conf make_conf retire_make_conf_cmd
	[ -z "${ret_def_tmp-}" ] || (cd /usr/ports/$port && make "__MAKE_CONF=$make_conf" PORT_DBDIR=/var/empty -DBATCH showconfig) >| "$ret_def_tmp"
	[ -z "${ret_opt_tmp-}" ] || (cd /usr/ports/$port && make "__MAKE_CONF=$make_conf" PORT_DBDIR="$PORT_DBDIR" -DBATCH showconfig) >| "$ret_opt_tmp"
	for action in build run; do
		eval local outfile=\"\$ret_${action}_tmp\"
		(cd /usr/ports/$port && make "__MAKE_CONF=$make_conf" PORT_DBDIR="$PORT_DBDIR" -DBATCH $action-depends-list | sed -e 's|^/usr/ports/||') >| "$outfile"
	done
	$retire_make_conf_cmd make_conf
	
	for new in def opt build run; do
		eval [ \"\$ret_${new}_var\" = _ ] || eval setvar \$ret_${new}_var \"\$ret_${new}_tmp\"
	done
}

pkg_deps () {
	local opt_installed= opt_missing= opt_ports=
	while getopts imp OPT; do case $OPT in
		i) opt_installed=y;;
		m) opt_missing=y;;
		p) opt_ports=y;;
	esac; done; shift $(($OPTIND-1))
	
	local ret_var=$1; shift
	local pkg=$1; shift
	
	[ $# = 0 ]
	local ret_tmp=
	require_tmp -l $ret_var ret_tmp
	
	exit 78
	
	setvar $ret_var "$ret_tmp"
}
