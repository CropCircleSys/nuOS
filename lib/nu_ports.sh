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

pkg_name () {
	local opt_installed=
	while getopts i OPT; do case $OPT in
		i) opt_installed=y;;
	esac; shift; done
	
	local port=$1; shift
	
	[ $# = 0 ]
	
	if [ -n "$opt_installed" ]; then
		pkg_info -qO $port
	else
		require_ports_tree
		(cd /usr/ports/$port && make -VPKGNAME)
	fi
}

pkg_orgn () {
	local opt_installed=
	while getopts i OPT; do case $OPT in
		i) opt_installed=y;;
	esac; shift; done
	
	local pkg=$1; shift
	
	[ $# = 0 ]
	
	if [ -n "$opt_installed" ]; then
		pkg_info -qo $pkg
	else
		exit 43
	fi
}

port_deps () {
	local ret_build_var=$1; shift
	local ret_run_var=$1; shift
	local port=$1; shift
	
	[ $# = 0 ]
	
	local ret_build_tmp=
	require_tmp -l $ret_build_var ret_build_tmp
	local ret_run_tmp=
	require_tmp -l $ret_run_var ret_run_tmp
	
	require_ports_tree
	
	local port_dir=/usr/ports/$port
	[ -d $port_dir ]
	
	local make_conf= retire_make_conf_cmd=
	prepare_make_conf make_conf retire_make_conf_cmd
	for action in build run; do
		eval local outfile=\"\$ret_${action}_tmp\"
		(cd /usr/ports/$port && make "__MAKE_CONF=$make_conf" -DBATCH $action-depends-list | sed -e 's|^/usr/ports/||') >| "$outfile"
	done
	$retire_make_conf_cmd "$make_conf"
	
	setvar $ret_build_var "$ret_build_tmp"
	setvar $ret_run_var "$ret_run_tmp"
}

pkg_deps () {
	local opt_installed= opt_missing= opt_ports=
	while getopts imp OPT; do case $OPT in
		i) opt_installed=y;;
		m) opt_missing=y;;
		p) opt_ports=y;;
	esac; shift; done
	
	local ret_var=$1; shift
	local pkg=$1; shift
	
	[ $# = 0 ]
	local ret_tmp=
	require_tmp -l $ret_var ret_tmp
	
	if [ -n "$opt_installed" ]; then
		[ -z "$opt_missing" ]
		local pkg_list=
		if [ -n "$opt_ports" ]; then
			require_tmp pkg_list
		else
			pkg_list=$ret_tmp
		fi
		pkg_info -qr $pkg | sed -ne '/^@pkgdep /{s///;p;}' >| "$pkg_list"
		if [ -n "$opt_port" ]; then
			cat "$pkg_list" | xargs -L1 pkg_info -qo >| "$ret_tmp"
		fi
	else
		local pkg_file=/usr/ports/packages/All/$pkg.tbz
		[ -f $pkg_file ]
		local field_no=
		if [ -n "$opt_ports" ]; then
			field_no=2
		else
			field_no=1
		fi
		if [ -n "$opt_missing" ]; then
			local pkg_add_output=
			require_tmp pkg_add_output
			if ! pkg_add ${CHROOTDIR:+-C $CHROOTDIR} -nv $pkg_file >| "$pkg_add_output"; then
				sed -nEe "/^Package '.*' depends on '.*' with '.*' origin./{
					N
					s/and was not found.\$/missing/
					s/ - already installed.\$/installed/
					s/^Package '[^']*' depends on '([^']*)' with '([^']*)' origin.\n(.*)\$/\1 \2 \3/
					p
				}" "$pkg_add_output" | grep -E '\<missing$' | cut -w -f $field_no >| "$ret_tmp"
			fi
			retire_tmp pkg_add_output
		else
			pkg_info -qv $pkg_file | sed -nEe '/^@pkgdep /{N;s/^@pkgdep ([[:graph:]]+)\n@comment DEPORIGIN:([[:graph:]]+)$/\1 \2/;p;}' | cut -w -f $field_no >| "$ret_tmp"
		fi
	fi
	
	setvar $ret_var "$ret_tmp"
}
