#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.0b0.1 - pkg/security_wpa_supplicant.sh - LICENSE: MOZ_PUB
#
# Copyright (c) 2008-2017 Chad Jacob Milios and Crop Circle Systems, Inc.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Mozilla Public License, v2.0.
# If a copy of the MPL was not distributed alongside this file, you can obtain one at
# http://mozilla.org/MPL/2.0/ . This software project is not affiliated with the Mozilla
# Foundation.
#
# Official updates and community support available at https://nuos.org .
# Other licensing options and professional services available at https://ccsys.com .

[ $NUOS_VER = 0.0.11.0b0.1 ]

case $pkg_step in
	post-build|post-install)
		cat >> "${destdir-}/etc/rc.conf" <<'EOF'
wpa_supplicant_program="/usr/local/sbin/wpa_supplicant"
EOF
		;;
	post-delete)
		sed -i '' -e '\|^wpa_supplicant_program="/usr/local/sbin/wpa_supplicant"|d' "${destdir-}/etc/rc.conf"
		;;
esac
