#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.2a1 - pkg/net_hostapd.sh
#
# Copyright (c) 2008-2018 Chad Jacob Milios and Crop Circle Systems.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Simplified BSD License.
# If a copy of the Simplified BSD License was not distributed alongside this file, you can
# obtain one at https://www.freebsd.org/copyright/freebsd-license.html . This software
# project is not affiliated with the FreeBSD Project.
#
# Official updates and community support available at https://nuos.org .
# Professional services available at https://ccsys.com .

[ $NUOS_VER = 0.0.11.2a1 ]

case $pkg_step in
	post-build|post-install)
		cat >> "${destdir-}/etc/rc.conf" <<'EOF'
hostapd_program="/usr/local/sbin/hostapd"
EOF
		;;
	post-delete)
		sed -i '' -e '\|^hostapd_program="/usr/local/sbin/hostapd"|d' "${destdir-}/etc/rc.conf"
		;;
esac
