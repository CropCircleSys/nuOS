#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.2b1 - lib/nu_common.sh - LICENSE: BSD_SMPL
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
[ -z "${nuos_lib_common_loaded-}" ]
nuos_lib_common_loaded=y

nuos_init () {
	if [ -r "${CHROOTDIR-}/usr/nuos/conf" ]; then
		. "${CHROOTDIR-}/usr/nuos/conf"
	fi
	if [ -r "${CHROOTDIR-}/etc/nuos.conf" ]; then
		. "${CHROOTDIR-}/etc/nuos.conf"
	fi
	echo 'nuos app v#                       ' $NUOS_VER
	echo 'nuos support       NUOS_SUPPORTED ' ${NUOS_SUPPORTED:=UNSUPPORTED}
	echo 'host opsys                        ' ${HOSTOS_TYPE:=$BASEOS_TYPE}
	echo 'host opsys v#                     ' ${HOSTOS_VER:=$BASEOS_VER}
}
