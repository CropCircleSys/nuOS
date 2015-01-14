#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.3b0 - lib/nu_collection.sh - LICENSE: BSD_SMPL
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
[ -n "${nuos_lib_system_loaded-}" ]
[ -z "${nuos_lib_collection_loaded-}" ]
nuos_lib_collection_loaded=y

collection_vars_init () {
	COLL_blank=
	COLL_bare='blank sysutils/memtest86+ sysutils/jail2'
	COLL_lite='bare sysutils/screen misc/buffer sysutils/pipemeter archivers/lzop sysutils/smartmontools net/rsync'
	COLL_developer='lite devel/subversion devel/git'
	COLL_server='developer mail/postfix sysutils/pefs-kmod security/gnupg dns/djbdns security/openvpn ftp/pure-ftpd net/isc-dhcp42-server net/netatalk3 net/samba36 security/tor net-p2p/rtorrent finance/vanitygen net-p2p/namecoin-daemon net-p2p/litecoin-daemon multimedia/ffmpeg25 lang/expect databases/postgresql93-server databases/mysql56-server databases/mongodb databases/redis www/npm www/apache24 www/nginx mail/cyrus-imapd24 security/cyrus-sasl2-saslauthd lang/phantomjs lang/clojure textproc/rubygem-sass emulators/virtualbox-ose graphics/povray-meta graphics/graphviz x11-fonts/webfonts lang/php56-extensions www/mod_php56 mail/roundcube-sieverules irc/irssi'
	COLL_desktop='server graphics/gimp x11/xorg x11/kde4 databases/virtuoso net-p2p/bitcoin net-p2p/namecoin net-p2p/litecoin net-p2p/retroshare net/x11vnc net/tightvnc www/firefox mail/thunderbird editors/libreoffice multimedia/vlc net-p2p/qbittorrent irc/kvirc'
}
