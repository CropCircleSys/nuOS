#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.3b0 - pkg/net_hostapd.sh - LICENSE: MOZ_PUB
#
# Copyright (c) 2008-2015 Chad Jacob Milios and Crop Circle Systems, Inc.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Mozilla Public License, v2.0.
# If a copy of the MPL was not distributed alongside this file, you can obtain one at
# http://mozilla.org/MPL/2.0/ . This software project is not affiliated with the Mozilla
# Foundation.
#
# Official updates and community support available at https://nuos.org .
# Other licensing options and professional services available at https://ccsys.com .

[ $NUOS_VER = 0.0.9.3b0 ]

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
