#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.2a24 - pkg/mail_roundcube.sh - LICENSE: MOZ_PUB
#
# Copyright (c) 2008-2014 Chad Jacob Milios and Crop Circle Systems, Inc.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Mozilla Public License, v2.0.
# If a copy of the MPL was not distributed alongside this file, you can obtain one at
# http://mozilla.org/MPL/2.0/ . This software project is not affiliated with the Mozilla
# Foundation.
#
# Official updates and community support available at http://nuos.org .
# Other licensing options and professional services available at http://ccsys.com .

[ $NUOS_VER = 0.0.9.2a24 ]

case $pkg_step in
	post-install)
		${destdir:+chroot "$destdir"} chown www:www /usr/local/www/roundcube/temp /usr/local/www/roundcube/logs
		;&
	post-build)
		mkdir -p "${destdir-}/usr/local/etc/roundcube"
		ln -s ../../../etc/roundcube/main.inc.php "${destdir-}/usr/local/www/roundcube/config/"
		ln -s ../../../etc/roundcube/db.inc.php "${destdir-}/usr/local/www/roundcube/config/"
		mkdir -p "${destdir-}/var/roundcube"
		mv "${destdir-}/usr/local/www/roundcube/temp" "${destdir-}/var/roundcube/" || (mv "${destdir-}/usr/local/www/roundcube/temp/.htaccess" "${destdir-}/var/roundcube/temp/" && rmdir "${destdir-}/usr/local/www/roundcube/temp")
		ln -s ../../../../var/roundcube/temp "${destdir-}/usr/local/www/roundcube/"
		[ ! -e "${destdir-}/var/log/roundcube" ] && mv "${destdir-}/usr/local/www/roundcube/logs" "${destdir-}/var/log/roundcube" || (mv "${destdir-}/usr/local/www/roundcube/logs/.htaccess" "${destdir-}/var/log/roundcube/" && rmdir "${destdir-}/usr/local/www/roundcube/logs")
		ln -s ../../../../var/log/roundcube "${destdir-}/usr/local/www/roundcube/logs"
		mkdir -p "${destdir-}/var/db/roundcube"
		chown www:www "${destdir-}/var/db/roundcube"
		;;
esac
