#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.2a25 - lib/nu_system.sh - LICENSE: BSD_SMPL
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

nuos_lib_ver=0.0.9.2a25
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -z "${nuos_lib_system_loaded-}" ]
nuos_lib_system_loaded=y

baseos_init () {
	if [ -r /usr/src/sys/conf/newvers.sh ]; then
		local TYPE REVISION BRANCH
		eval `grep -E '^(TYPE|REVISION|BRANCH)=' /usr/src/sys/conf/newvers.sh`
		BASEOS_TYPE=$TYPE
		BASEOS_VER=$REVISION-$BRANCH
	else
		BASEOS_TYPE=`uname -s`
		BASEOS_VER=`uname -r`
	fi
	if [ -q != "${1-}" ]; then
		echo 'base opsys                        ' $BASEOS_TYPE
		echo 'base opsys v#                     ' $BASEOS_VER
	fi
}

maybe_pause () {
	if [ -z "${OPT_QUICK-}" ]; then
		echo
		echo beginning in 10 seconds
		echo
		sleep 10
		echo
	fi
}

maybe_yell () {
	if [ -n "${OPT_VERBOSE-}" ]; then
		set -v; set -x
	fi
}

push () {
	local var=$1; shift
	eval setvar $var \"\${$var:+\$$var }$*\"
}

sister () {
	local bin=$1; shift
	sh "$(dirname "$(realpath "$0")")/$bin" "$@"
}

require_tmp () {
	local opt_dir= label; unset label
	while getopts dl: OPT; do case $OPT in
		d) opt_dir=y;;
		l) label=$OPTARG;
	esac; done; shift $(($OPTIND-1))
	
	[ $# = 1 ]
	[ -n "$1" ]
	
	: ${label=$1}
	
	if eval [ -n \"\${$1-}\" ]; then
		eval [ -w \"\$$1\" ]
	else
		setvar "$1" "$(mktemp ${opt_dir:+-d} -t "$(basename "$0").$$${label:+.$label}")"
	fi
}

retire_tmp () {
	local opt_keep=
	while getopts k OPT; do case $OPT in
		k) opt_keep=y;;
	esac; done; shift $(($OPTIND-1))
	
	[ $# = 1 ]
	[ -n "$1" ]
	
	if [ -z "$opt_keep" ]; then
		if [ -n "${OPT_DEBUG-}" ]; then
			require_tmp -d -l debug_out _retire_tmp_debug_out
			if eval [ -e \"\$_retire_tmp_debug_out\/\$1\" ]; then
				eval mv -n \"\$_retire_tmp_debug_out\/\$1\" \"\$_retire_tmp_debug_out\/0.\$1\"
			fi
			local i; unset i
			while eval [ -e \"\$_retire_tmp_debug_out\/${i:-0}.\$1\" ]; do
				: ${i:=0}
				i=$(($i+1))
			done
			eval mv -n \"\$$1\" \"\$_retire_tmp_debug_out\/${i:+$i.}\$1\"
		else
			eval rm -r \"\$$1\"
		fi
	fi
	eval unset "$1"
}

choose_random () {
	local var=$1; shift
	local rand=$((`dd bs=4 count=1 if=/dev/urandom 2> /dev/null | od -D | head -n 1 | cut -w -f 2` % $# + 1))
	eval setvar $var \$$rand
}

sets_union () {
	local ret_var=$1; shift
	
	[ $# -ge 1 ]
	
	local ret_tmp=
	require_tmp -l $ret_var ret_tmp
	
	cat "$@" | sort -u >| "$ret_tmp"
	setvar $ret_var "$ret_tmp"
}

sets_sym_diff () {
	local ret_var=$1; shift
	
	[ $# = 2 ]
	
	local ret_tmp=
	require_tmp -l $ret_var ret_tmp
	
	cat "$@" | sort | uniq -u >| "$ret_tmp"
	setvar $ret_var "$ret_tmp"
}

sets_intrsctn () {
	local ret_var=$1; shift
	
	[ $# -ge 2 ]
	
	local ret_tmp=
	require_tmp -l $ret_var ret_tmp
	
	case $# in
		2)
			cat "$@" | sort | uniq -d >| "$ret_tmp"
			;;
		*)
			cat "$@" | sort | uniq -c | sed -nEe "/^[[:blank:]]*$# /{s///;p;}" >| "$ret_tmp"
	esac
	setvar $ret_var "$ret_tmp"
}
