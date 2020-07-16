#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.4a0 - pkg/dns_nss_mdns.sh
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

[ $NUOS_VER = 0.0.11.4a0 ]

case $pkg_step in
	post-build|post-install)
		sed -i '' -Ee '/^hosts:/{s/ ?\<mdns\>//g;s/$/ mdns/;}' "${destdir-}/etc/nsswitch.conf"
		;;
	post-delete)
		sed -i '' -Ee '/^hosts:/s/ ?\<mdns\>//g' "${destdir-}/etc/nsswitch.conf"
		;;
esac
