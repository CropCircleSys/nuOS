#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.3a0 - lib/nu_common.sh
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
[ -z "${nuos_lib_common_loaded-}" ]
nuos_lib_common_loaded=y

nuos_init () {
	for conf_file in /usr/nuos/conf /etc/nuos.conf /etc/nuos/conf; do
		if [ -r "$conf_file" ]; then
			. "$conf_file"
		fi
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
		SSL_CONF=/usr/local/openssl/openssl.cnf
		[ -e $SSL_CONF ] || cp $SSL_CONF.sample $SSL_CONF
	else
		SSL_CMD=/usr/bin/openssl
		SSL_SUITE=openssl-freebsd-base
		SSL_CONF=/etc/ssl/openssl.cnf
	fi
	: ${HOST:=`hostname`}
	if [ ${HOST%%.*} != "`readlink /etc/ssl/certs.installed/localhost`" ]; then
		mkdir -p /etc/ssl/certs.installed/${HOST%%.*}
		ln -sf ${HOST%%.*} /etc/ssl/certs.installed/localhost
	fi
}

nuos_ssh_init () {
	if [ -x /usr/local/bin/ssh ]; then
		SSH_CMD=/usr/local/bin/ssh
		SSH_SUITE=openssh-port
	else
		SSH_CMD=/usr/bin/ssh
		SSH_SUITE=openssh-freebsd-base
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

ns_master_zone () {
	local opt_chroot= alternate= chrootdir= zone= host_name=; unset alternate chrootdir
	while getopts A:cC:j: OPT; do case $OPT in
		A) alternate=$OPTARG;;
		c) opt_chroot=y;;
		C) chrootdir=$OPTARG;;
		j) jailname=$OPTARG;;
	esac; done; shift $(($OPTIND-1))
	[ $# -eq 1 ]
	host_name=$1; shift
	zone=$host_name
	
	if [ -n "${jailname-}" ]; then
		chrootdir="`jls -j $jailname path`"
		opt_chroot=y
		[ -n "$chrootdir" ] || { echo "could not find running jail thusly named." >&2 && return 85; }
	fi
	
	while [ ! -f "${opt_chroot:+${chrootdir-$CHROOTDIR}}/var/db/knot${alternate:+_${alternate}}/$zone.zone" ]; do
		echo $zone | grep -q '\.' || { echo "could not find zone file (are we the configured master of a parent zone?)" >&2 && return 85; }
		zone=${zone#*.}
	done
	echo $zone
}

set_primary_phys_netif () {
	local primary_if=$1
	local trgt=${2-}
	sed -i '' -E -e '/^ifconfig_.+_name="?net0"?/d' "$trgt/etc/rc.conf.local"
	cat >> "$trgt/etc/rc.conf.local" <<EOF
ifconfig_${primary_if}_name="net0"
EOF
}
