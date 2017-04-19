#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.0b0.1 - pkg/databases_postgresql93-server.sh - LICENSE: MOZ_PUB
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
		if [ ! -d "${destdir-}/var/db/pgsql" ]; then
			mv "${destdir-}/usr/local/pgsql" "${destdir-}/var/db/"
		fi
		${destdir:+chroot "$destdir"} pw usermod pgsql -d /var/db/pgsql
		;;
esac