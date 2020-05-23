#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.3a0 - lib/nu_ports.sh
#
# Copyright (c) 2008-2019 Chad Jacob Milios and Crop Circle Systems.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Simplified BSD License.
# If a copy of the Simplified BSD License was not distributed alongside this file, you can
# obtain one at https://www.freebsd.org/copyright/freebsd-license.html . This software
# project is not affiliated with the FreeBSD Project.
#
# Official updates and community support available at https://nuos.org .
# Professional services available at https://ccsys.com .

nuos_lib_ver=0.0.11.3a0
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


ports_tag () {
	if [ -d /usr/ports/.svn ]; then
		save_svn_info -r /usr/ports
	else
		cut -d '|' -f 2 /var/db/portsnap/tag
	fi
}

pkg_db_tag () {
	[ -d "${CHROOTDIR-}/var/db/nuos/pkg" -a ! -L "${CHROOTDIR-}/var/db/nuos/pkg" -a -f "${CHROOTDIR-}/var/db/nuos/pkg/tag" ]
	cat "${CHROOTDIR-}/var/db/nuos/pkg/tag"
}

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
		mkdir /usr/ports/packages/All 2> /dev/null || true
	fi
	local pkg_meta="$(dirname "$(realpath "$0")")/../pkg"
	local port_shars="`cd "$pkg_meta" && ls *.shar 2> /dev/null`"
	for port_shar in $port_shars; do
		local shar_ver= port=`echo $port_shar | sed -e 's|_|/|;s/\.shar$//'`
		if [ $port != ${port%.REPLACE_v*} ]; then
			shar_ver="${port##*.REPLACE_v}"
			port="${port%.REPLACE_v$shar_ver}"
			if [ "`cat /usr/ports/$port/.nuOS_shar_ver 2> /dev/null`" != $shar_ver ]; then
				mv -nhv /usr/ports/$port /usr/ports/$port.$$.bak 2> /dev/null || true
				# TODO: fix race condition here
				# XXX: only reach here through nu_pkg_tree or nu_update, not nu_install_pkg
			fi
		fi
		if [ ! -e /usr/ports/$port ]; then
			local category=${port%/*}
			(cd /usr/ports/$category && sh "$pkg_meta"/$port_shar)
			if [ -n "$shar_ver" ]; then
				echo $shar_ver > /usr/ports/$port/.nuOS_shar_ver
				rm -rv /usr/ports/$port.$$.bak 2> /dev/null || true
			fi
		fi
	done
	local port_diff= port_diffs=
	port_diffs="`cd "$pkg_meta" && ls *.1.diff 2> /dev/null`"
	for port_diff in $port_diffs; do
		local i= port_= port= targ=
		port_=${port_diff%.1.diff}
		port=`echo $port_ | sed -e 's|_|/|'`
		if (cd /usr/ports/$port && . "$pkg_meta"/$port_.diff.test); then
			if [ -f /usr/ports/$port/.nuOS_diff_test ]; then
				echo "WARNING: patch for $port seems to have been applied yet still passes need-to-apply test." >&2
				sleep 15
			fi
			i=1
			while [ -f "$pkg_meta"/$port_.$i.diff ]; do
				targ=`head -n 2 "$pkg_meta"/$port_.$i.diff | tail -n 1 | cut -w -f 2`
				patch -s -C -F 0 -E -t -N -d /usr/ports/$port -i "$pkg_meta"/$port_.$i.diff $targ || { echo "ERORR: patch for $port failed." >&2 && exit 1; }
				patch -F 0 -E -t -N -d /usr/ports/$port -i "$pkg_meta"/$port_.$i.diff $targ
				i=$(($i+1))
			done
			sha256 -q "$pkg_meta"/$port_.diff.test >| /usr/ports/$port/.nuOS_diff_test
		elif [ ! -f /usr/ports/$port/.nuOS_diff_test ]; then
			echo "WARNING: patch for $port does not pass its need-to-apply test but does not seem to have been applied." >&2
			sleep 15
		fi
	done
}

pkg_name () {
	local port_= metainfo_dir= makeargs= opt_db= opt_installed= output=
	while getopts di OPT; do case $OPT in
		d) opt_db=y;;
		i) opt_installed=y;;
	esac; done; shift $(($OPTIND-1))

	local port=$1; shift

	[ $# = 0 ]

	port_=`echo $port | tr / _`
	if [ -n "$opt_db" ]; then
		cat "${CHROOTDIR-}/var/db/nuos/pkg/$port_/name"
	elif [ -n "$opt_installed" ]; then
		exit 78
		output=`${CHROOTDIR:+chroot "$CHROOTDIR"} pkg info -qO ${port%%@*}`
		case $port in
			*@*)
				for pkg in $output; do
					if [ ${port##*@} = "`pkg info -qA $pkg | sed -nEe '/^flavor[[:blank:]]*:[[:blank:]]*/{s///;p;}'`" ]; then
						echo $pkg
					fi
				done
			;;
			*)
				if [ -n "$output" ]; then
					echo $output
				fi
			;;
		esac
	else
		local make_conf= retire_make_conf_cmd= flavor=
		prepare_make_conf make_conf retire_make_conf_cmd
		case $port in
			*@*)
				flavor=${port##*@}
			;;
		esac
		metainfo_dir="$(dirname "$(realpath "$0")")/../pkg"
		makeargs="$metainfo_dir/$port_.makeargs"
		(cd /usr/ports/${port%%@*} && make "__MAKE_CONF=$make_conf" PORT_DBDIR="$PORT_DBDIR" ${flavor:+FLAVOR=$flavor} `cat "$makeargs" 2>/dev/null` -VPKGNAME)
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
	for new in def opt lib run build fetch extract patch; do
		eval local ret_${new}_var=\$1; shift
		if eval [ \"\$ret_${new}_var\" != _ ]; then
			eval local ret_${new}_tmp=
			eval require_tmp -l \$ret_${new}_var ret_${new}_tmp
		fi
	done
	local port=$1; shift

	[ $# = 0 ]

	local port_dir=/usr/ports/${port%%@*}
	[ -d $port_dir ]

	local port_= metainfo_dir= makeargs= make_conf= retire_make_conf_cmd= flavor=
	prepare_make_conf make_conf retire_make_conf_cmd
	case $port in
		*@*)
			flavor=${port##*@}
		;;
	esac
	metainfo_dir="$(dirname "$(realpath "$0")")/../pkg"
	port_=`echo $port | tr / _`
	makeargs="$metainfo_dir/$port_.makeargs"
	[ -z "${ret_def_tmp-}" ] || (cd $port_dir && make "__MAKE_CONF=$make_conf" PORT_DBDIR=/var/empty ${flavor:+FLAVOR=$flavor} `cat "$makeargs" 2>/dev/null` -D BATCH showconfig) >| "$ret_def_tmp"
	[ -z "${ret_opt_tmp-}" ] || (cd $port_dir && make "__MAKE_CONF=$make_conf" PORT_DBDIR="$PORT_DBDIR" ${flavor:+FLAVOR=$flavor} `cat "$makeargs" 2>/dev/null` -D BATCH showconfig) >| "$ret_opt_tmp"
	for action in lib run build fetch extract patch; do
		eval local outfile=\"\$ret_${action}_tmp\"
		if [ $action = build -a $port != ports-mgmt/pkg ]; then
			echo ports-mgmt/pkg >| "$outfile"
		fi
		(cd $port_dir && make "__MAKE_CONF=$make_conf" PORT_DBDIR="$PORT_DBDIR" ${flavor:+FLAVOR=$flavor} `cat "$makeargs" 2>/dev/null` -D BATCH -V $(echo $action | tr [:lower:] [:upper:])_DEPENDS | xargs -n 1 | cut -d : -f 2) >> "$outfile"
	done
	$retire_make_conf_cmd make_conf

	for new in def opt lib run build fetch extract patch; do
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
