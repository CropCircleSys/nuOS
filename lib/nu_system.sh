#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.2b1 - lib/nu_system.sh - LICENSE: BSD_SMPL
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

nuos_lib_ver=0.0.9.2b1
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
		echo 'beginning in 10 seconds'
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
	local var=$1
	shift
	eval setvar \$var \"\${$var:+\$$var }$*\"
}

sister () {
	local bin=$1
	shift
	(sh "$(dirname "$(realpath "$0")")/$bin" "$@")
}

require_tmp () {
	eval [ -n "\${$1-}" ] || setvar $1 `mktemp -d -t $(basename "$0").$$`
}
