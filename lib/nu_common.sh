#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.0b0.1 - lib/nu_common.sh - LICENSE: BSD_SMPL
#
# Copyright (c) 2008-2017 Chad Jacob Milios and Crop Circle Systems, Inc.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Simplified BSD License.
# If a copy of the Simplified BSD License was not distributed alongside this file, you can
# obtain one at http://www.freebsd.org/copyright/freebsd-license.html . This software
# project is not affiliated with the FreeBSD Project.
#
# Official updates and community support available at https://nuos.org .
# Other licensing options and professional services available at https://ccsys.com .

nuos_lib_ver=0.0.11.0b0.1
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -z "${nuos_lib_common_loaded-}" ]
nuos_lib_common_loaded=y

nuos_init () {
	for conf_file in /usr/nuos/conf /etc/nuos.conf /etc/nuos/conf; do
		if [ -r "${CHROOTDIR-}$conf_file" ]; then
			. "${CHROOTDIR-}$conf_file"
		fi
	done
	
	: ${NUOS_SUPPORTED:=UNSUPPORTED}
	: ${HOSTOS_TYPE:=$BASEOS_TYPE}
	: ${HOSTOS_VER:=$BASEOS_VER}
	: ${HOSTOS_ARCH:=`uname -m`}
	: ${HOSTOS_PROC:=`uname -p`}
	if [ $HOSTOS_ARCH = $HOSTOS_PROC ]; then
		HOSTOS_MACH=$HOSTOS_ARCH
	else
		HOSTOS_MACH=$HOSTOS_ARCH.$HOSTOS_PROC
	fi
	if [ -q != "${1-}" ]; then
		echo 'nuos app v#                       ' $NUOS_VER
		echo 'nuos support       NUOS_SUPPORTED ' "$NUOS_SUPPORTED"
		echo 'host opsys                        ' "$HOSTOS_TYPE"
		echo 'host opsys v#                     ' $HOSTOS_VER
		echo "host pkg collec'n                 " ${HOSTOS_PKG_COLLECTION-n/a}
	fi
}

nuos_ssl_init () {
	if [ -x /usr/local/bin/openssl ]; then
		SSL_CMD=/usr/local/bin/openssl
		SSL_SUITE=openssl-port
		if [ ! -e /usr/local/openssl/openssl.cnf ]; then
			cp /usr/local/openssl/openssl.cnf.sample /usr/local/openssl/openssl.cnf
		fi
	else
		SSL_CMD=/usr/bin/openssl
		SSL_SUITE=openssl-freebsd-base
	fi
}

nuos_sha_fngr () {
	local bytes=24
	while getopts b:f OPT; do case $OPT in
		b) bytes=$OPTARG; [ $bytes -ge 1 -a $bytes -le 43 ];;
		f) opt_force=y;;
	esac; done; shift $(($OPTIND-1))
	[ $# -ge 1 ]
	[ $bytes -le 42 -o -n "${opt_force-}" ]
	
	cat "$@" 2>/dev/null |
		sha256 -q |
		(echo 16i; echo -n FF; tr a-f A-F; echo P) | dc | tail -c +2 |
		b64encode - |
		sed -nEe "
			/^begin-base64 /{
				n
				s/=?=\$//
				y|+/|-_|
				s/^(.{$bytes}).*\$/\1/
				p
				q
			}"
}
