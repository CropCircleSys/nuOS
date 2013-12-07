#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.2d12 - lib/nu_ports.sh - LICENSE: BSD_SMPL
#
# Copyright (c) 2008-2013 Chad Jacob Milios and Crop Circle Systems, Inc.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Simplified BSD License.
# If a copy of the Simplified BSD License was not distributed alongside this file, you can
# obtain one at http://www.freebsd.org/copyright/freebsd-license.html . This software
# project is not affiliated with the FreeBSD Project.
#
# Official updates and community support available at http://nuos.org .
# Other licensing options and professional services available at http://ccsys.com .

nuos_lib_ver=0.0.9.2d12
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -n "${nuos_lib_system_loaded-}" ]
[ -n "${nuos_lib_make_loaded-}" ]
[ -z "${nuos_lib_ports_loaded-}" ]
nuos_lib_ports_loaded=y

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
	if [ ! -d /usr/ports/packages/All ]; then
		mkdir /usr/ports/packages/All
	fi
}

port_deps () {
	local ret_build_tmp=$1; shift
	local ret_run_tmp=$1; shift
	local port=$1; shift
	
	[ $# = 0 ]
	[ -w "$ret_build_tmp" -a ! -s "$ret_build_tmp" ]
	[ -w "$ret_run_tmp" -a ! -s "$ret_run_tmp" ]
	
	require_ports_tree
	
	local port_dir=/usr/ports/$port
	[ -d $port_dir ]
	
	local make_conf= retire_make_conf_cmd=
	prepare_make_conf make_conf retire_make_conf_cmd
	for action in build run; do
		local outfile=`eval echo '"$ret_'$action'_tmp"'`
		(cd /usr/ports/$port && make "__MAKE_CONF=$make_conf" -DBATCH $action-depends-list | sed -e 's|^/usr/ports/||') >| "$outfile"
	done
	$retire_make_conf_cmd "$make_conf"
}

pkg_deps () {
	local opt_missing=
	while getopts m OPT; do case $OPT in
		m) opt_missing=y;;
	esac; shift; done
	
	local ret_tmp=$1; shift
	local pkg=$1; shift
	
	[ $# = 0 ]
	[ -w "$ret_tmp" -a ! -s "$ret_tmp" ]
	
	local pkg_file=/usr/ports/packages/All/$pkg.tbz
	[ -f $pkg_file ]
	
	if [ -n "$opt_missing" ]; then
		local pkg_add_output=
		require_tmp pkg_add_output
		if ! pkg_add ${CHROOTDIR:+-C $CHROOTDIR} -nv $pkg_file >| "$pkg_add_output"; then
			sed -nEe "/^Package '.*' depends on '.*' with '.*' origin./{
				N
				s/and was not found.\$/missing/
				s/ - already installed.\$/installed/
				s/^Package '(.*)' depends on '(.*)' with '(.*)' origin.\n(.*)\$/\1 \2 \3 \4/
				p
			}" "$pkg_add_output" | grep -E '\<missing$' | cut -w -f 3 >| "$ret_tmp"
		fi
		retire_tmp pkg_add_output
	else
		pkg_info -qv $pkg_file | sed -nEe '/^@pkgdep /{N;s/^@pkgdep ([[:graph:]]+)\n@comment DEPORIGIN:([[:graph:]]+)$/\1 \2/;p;}' | cut -w -f 2 >| "$ret_tmp"
	fi
}
