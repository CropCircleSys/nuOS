#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.3b0 - lib/nu_jail.sh - LICENSE: BSD_SMPL
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
[ -n "${nuos_lib_common_loaded-}" ]
[ -z "${nuos_lib_jail_loaded-}" ]
nuos_lib_jail_loaded=y

jail_vars_init () {
	echo 'creating jail   -j JAIL_NAME      ' ${JAIL_NAME:=clink}
	echo 'jail type       -t JAIL_TYPE      ' ${JAIL_TYPE:=jail}
	echo 'jail opsys      -o JAIL_OS        ' ${JAIL_OS:=$HOSTOS_TYPE/$HOSTOS_VER}
	echo 'pool name       -p POOL_NAME      ' ${POOL_NAME:=$POOL_BOOT_NAME}
	echo 'jail snapshot   -s JAIL_SNAP      ' ${JAIL_SNAP:=base}
	echo 'jail dataset       JAIL_DATA      ' ${JAIL_DATA:=$POOL_NAME/jail/$JAIL_NAME}
	echo 'jail path          JAIL_PATH      ' ${JAIL_PATH:=/var/jail/$JAIL_NAME}
	local hostname=${NEW_HOST:-`hostname`}
	echo 'jail host name  -h JAIL_HOST      ' ${JAIL_HOST:=$JAIL_NAME.$hostname}
	echo 'jail ip address -i JAIL_IP        ' ${JAIL_IP:=`
		awk '
			/^127\.[0-9]+\.[0-9]+\.[0-9]+/{
				split(\$1, n, ".")
				printf("%03i%03i%03i\n", n[2], n[3], n[4])
			}' "${CHROOTDIR-}/etc/hosts" |
		sort -n |
		tail -1 |
		awk '{
			x = substr(\$1, 1, 3) * 1
			if ( x < 1 ) {
				x = 1; y = 0; z = 0
			} else {		
				y = substr(\$1, 4, 3) * 1
				z = substr(\$1, 7, 3) + 1
				if ( z > 255 ) {
					z = 0
					y++
				}
				if ( y > 255 ) {
					y = 0
					x++
				}
			}
			if (x < 256 && y < 256 && z < 256 && x + y + z < (3 * 255)) {
				print 127 "." x "." y "." z
			} else {
				print "ERANGE"
			}
		}'
	`}
	[ -n "$JAIL_IP" -a $JAIL_IP = ${JAIL_IP#E} ]
	echo -n 'shared src mnts -w OPT_RW_SRC      ' && [ -n "${OPT_RW_SRC-}" ] && echo set || echo null
}
