#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.4a0 - lib/nu_system.sh
#
# Copyright (c) 2008-2020 Chad Jacob Milios and Crop Circle Systems.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Simplified BSD License.
# If a copy of the Simplified BSD License was not distributed alongside this file, you can
# obtain one at https://www.freebsd.org/copyright/freebsd-license.html . This software
# project is not affiliated with the FreeBSD Project.
#
# Official updates and community support available at https://nuos.org .
# Professional services available at https://ccsys.com .

nuos_lib_ver=0.0.11.4a0
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -z "${nuos_lib_system_loaded-}" ]
nuos_lib_system_loaded=y

: ${TMPDIR:=/tmp}

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
		echo 'base opsys			' $BASEOS_TYPE
		echo 'base opsys v#		     ' $BASEOS_VER
	fi
}

maybe_pause () {
	local secs="${1-}"
	if [ -z "${OPT_QUICK-}" ]; then
		echo
		echo beginning in ${secs:=10} seconds
		echo
		sleep $secs
		echo
	fi
}

maybe_yell () {
	if [ -n "${OPT_VERBOSE-}" ]; then
		set -v; set -x
	fi
}

srsly () {
	case "${1-}" in
		y) return 0;;
		'') return 1;;
		*) echo ERROR: confusing boolean "($*)"; exit 88;;
	esac
}

canhas () {
	if [ -n "${1-}" ]; then
		return 0
	else
		return 1
	fi
}

first () {
	case "$2" in
		of)
			if [ "$1" = "${3%% *}" ]; then
				return 0
			else
				return 1
			fi
		;;
		*) exit 88;;
	esac
}

incr () {
	local var=$1; shift
	if eval [ -z "\"\${$var-}\"" ]; then
		setvar $var $1
	elif eval [ \$$var -ge ${2-9223372036854775806} ]; then
		return 1
	else
		eval setvar $var "\$((1+\$$var))"
	fi
}

push () {
	local var=$1 old_val= prepend= new_val=; shift
	eval old_val=\"\${$var-}\"
	prepend="${old_val:+$old_val }"
	new_val="$prepend$*"
	setvar $var "$new_val"
}

humanize () {
	[ -n "$1" ]
	if [ "$((($1 / 1125899906842624) * 1125899906842624))" = "$1" ]; then
		echo "$(($1 / 1125899906842624)) PB"
	elif [ "$((($1 / 1099511627776) * 1099511627776))" = "$1" ]; then
		echo "$(($1 / 1099511627776)) TB"
	elif [ "$((($1 / 1073741824) * 1073741824))" = "$1" ]; then
		echo "$(($1 / 1073741824)) GB"
	elif [ "$((($1 / 1048576) * 1048576))" = "$1" ]; then
		echo "$(($1 / 1048576)) MB"
	elif [ "$((($1 / 1024) * 1024))" = "$1" ]; then
		echo "$(($1 / 1024)) KB"
	else
		echo "$1 B"
	fi
}

error () {
	local ex=$1; shift
	printf '%s\n' "ERROR: $*" 2>&1
	exit $1
}

spill () {
	local var=$1 val=
	if eval [ -z \"\${$var-}\" -a -n \"\${$var-x}\" ]; then
		return
	fi
	eval setvar val \"\$$var\"
	echo -n "$var="
	printf %s "$val" | case y in
		`printf %s "$val" | grep -q \' && echo y`)
				echo -n \"
				sed -e 's/\\/\\\\/g;s/`/\\`/g;s/"/\\"/g;s/\$/\\&/g'
				echo \"
		;;
		`printf %s "$val" | awk 'NR==2{print "$";exit}{print $0}' | grep -qE '[^[:alnum:]./_@%^+=:-]' && echo y`)
				echo -n \'
				cat
				echo \'
		;;
		*)
				cat
				echo
		;;
	esac
}

mnt_dev () {
	if [ -c "${1-}/dev/null" ]; then
		return 1
	else
		mount -t devfs devfs "${1-}/dev"
		devfs -m "${1-}/dev" ruleset 1
		devfs -m "${1-}/dev" rule applyset
		devfs -m "${1-}/dev" rule -s 2 applyset
	fi
}

sister () {
	local chrootdir= jailname=; unset chrootdir jailname
	while getopts C:j: OPT; do case $OPT in
		C) chrootdir=$OPTARG;;
		j) jailname=$OPTARG;;
	esac; done; shift $(($OPTIND-1))
	local bin=$1; shift
	
	if [ -n "${jailname-}" ]; then
		chrootdir="`jls -j $jailname path`"
		[ -n "$chrootdir" ] || { echo "could not find running jail thusly named." >&2 && return 85; }
	fi
	
	if [ -n "${chrootdir-}" ]; then
		local nuos_src
		require_tmp -c -C "$chrootdir" -d nuos_src
		mount -t nullfs -r "$(dirname "$(realpath "$0")")/.." "$nuos_src"
		local devfs_mounted=
		if mnt_dev "$chrootdir"; then
			devfs_mounted=y
		fi
		if [ -n "${jailname-}" ]; then
			jexec -l "$jailname" sh "${nuos_src#"$chrootdir"}/bin/$bin" "$@"
		else
			chroot "$chrootdir" sh "${nuos_src#"$chrootdir"}/bin/$bin" "$@"
		fi
		if [ -n "$devfs_mounted" ]; then
			umount "$chrootdir/dev"
		fi
		umount "$nuos_src"
		retire_tmp nuos_src
	else
		sh "$(dirname "$(realpath "$0")")/$bin" "$@"
	fi
}

require_tmp () {
	local opt_chroot= chrootdir= opt_dir= label=; unset chrootdir label
	while getopts cC:dl: OPT; do case $OPT in
		c) opt_chroot=y;;
		C) chrootdir=$OPTARG;;
		d) opt_dir=y;;
		l) label=$OPTARG;;
	esac; done; shift $(($OPTIND-1))
	
	[ $# = 1 ]
	[ -n "$1" ]
	
	: ${label=$1}
	
	if eval [ -n \"\${$1-}\" ]; then
		eval [ -w \"\$$1\" ]
	else
		setvar "$1" "$(env TMPDIR="${opt_chroot:+${chrootdir-$CHROOTDIR}}$TMPDIR" mktemp ${opt_dir:+-d} -t "$(basename "$0").$$${label:+.$label}")"
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

rev_zone () {
	echo $1 | awk 'FS=OFS="."{print $4,$3,$2,$1,"in-addr.arpa"}'
}

try () {
	local tries=$1; shift
	for n in `seq 1 $tries`; do
		if "$@"; then
			return
		else
			sleep 1
		fi
	done
	return 1
}

next_ip () {
	echo "${1%.*}.$((${1##*.}+1))"
}

save_svn_info () {
	local code_dir= opt_rev= r=
	if [ x-r = "x${1-}" ]; then
		opt_rev=y; shift
	fi
	code_dir="${1:-`realpath .`}"
	if ! [ "$code_dir/.svn/info.txt" -nt "$code_dir/.svn/wc.db" ]; then
		(cd /var/empty && env TZ=UTC svn`which svn > /dev/null 2>&1 || echo lite` info "$code_dir") >| "$code_dir/.svn/info.txt"
	fi
	if srsly ${opt_rev-}; then
		r=`grep ^Revision: "$code_dir/.svn/info.txt" | cut -w -f 2`
		: ${r:=0}
		echo r$r
	fi
}
