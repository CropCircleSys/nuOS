#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.3a0 - pkg/mail_roundcube.sh
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

[ $NUOS_VER = 0.0.11.3a0 ]

case $pkg_step in
	post-build|post-install)
		mkdir -p "${destdir-}/usr/local/etc/roundcube"
		ln -s ../../../etc/roundcube/config.inc.php "${destdir-}/usr/local/www/roundcube/config/" || ([ -L "${destdir-}/usr/local/www/roundcube/config/config.inc.php" ] && ln -s -f ../../../etc/roundcube/config.inc.php "${destdir-}/usr/local/www/roundcube/config/")
		mkdir -p "${destdir-}/var/roundcube/temp"
		chown www:www "${destdir-}/var/roundcube/temp"
		rm -rv "${destdir-}/usr/local/www/roundcube/temp"
		ln -s ../../../../var/roundcube/temp "${destdir-}/usr/local/www/roundcube/"
		mkdir -p "${destdir-}/var/log/roundcube"
		chown www:www "${destdir-}/var/log/roundcube"
		rm -rv "${destdir-}/usr/local/www/roundcube/logs"
		ln -s ../../../../var/log/roundcube "${destdir-}/usr/local/www/roundcube/logs"
		mkdir -p "${destdir-}/var/db/roundcube"
		chown www:www "${destdir-}/var/db/roundcube"
		;;
	pre-delete)
		[ -L "${destdir-}/usr/local/www/roundcube/config/config.inc.php" ]
		rm "${destdir-}/usr/local/www/roundcube/config/config.inc.php"
		[ -L "${destdir-}/usr/local/www/roundcube/temp" ]
		rm "${destdir-}/usr/local/www/roundcube/temp"
		tar -cnpf - -C "${destdir-}/var/roundcube/" temp | tar -xpf - -C "${destdir-}/usr/local/www/roundcube/"
		rm -r "${destdir-}/var/roundcube/temp/"
		[ -L "${destdir-}/usr/local/www/roundcube/logs" ]
		rm "${destdir-}/usr/local/www/roundcube/logs"
		tar -cnpf - -C "${destdir-}/var/log/" roundcube | tar -xpf - -s '|^roundcube/|logs/|' -C "${destdir-}/usr/local/www/roundcube/"
		;;
esac
