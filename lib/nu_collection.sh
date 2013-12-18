#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.9.2a23 - lib/nu_collection.sh - LICENSE: BSD_SMPL
#
# Copyright (c) 2008-2013 Chad Jacob Milios and Crop Circle Systems, Inc.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Simplified BSD License.
# If a copy of the Simplified BSD License was not distributed alongside this file, you can
# obtain one at http://www.freebsd.org/copyright/freebsd-license.html . This software
# project is not affiliated with the FreeBSD Project.
#
# Official updates and community support available at http://nuos.org .
# Other licensing options and professional services available at http://ccsys.com .

nuos_lib_ver=0.0.9.2a23
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -n "${nuos_lib_system_loaded-}" ]
[ -z "${nuos_lib_collection_loaded-}" ]
nuos_lib_collection_loaded=y

collection_vars_init () {
	COLL_blank=
	COLL_bare='blank sysutils/memtest86+ sysutils/jail2'
	COLL_lite='bare sysutils/screen misc/buffer sysutils/pipemeter archivers/lzop sysutils/smartmontools net/rsync'
	COLL_developer='lite devel/subversion devel/git ports-mgmt/portupgrade'
	COLL_server='developer mail/postfix sysutils/pefs-kmod security/gnupg dns/djbdns security/openvpn ftp/pure-ftpd net/netatalk3 net/samba36 net-p2p/rtorrent net-p2p/bitcoin-daemon net-p2p/litecoin-daemon www/py-rhodecode databases/postgresql92-server databases/mongodb databases/redis www/npm www/apache24 mail/cyrus-imapd24 security/cyrus-sasl2-saslauthd emulators/virtualbox-ose graphics/povray-meta graphics/graphviz x11-fonts/webfonts print/teTeX lang/php55-extensions mail/roundcube-sieverules'
	COLL_desktop='server graphics/gimp x11/xorg x11/kde4 net-p2p/bitcoin net-p2p/litecoin net-p2p/retroshare net/x11vnc net/tightvnc www/firefox mail/thunderbird editors/libreoffice multimedia/vlc'
}
