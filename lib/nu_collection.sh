#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.1a1 - lib/nu_collection.sh - LICENSE: BSD_SMPL
#
# Copyright (c) 2008-2017 Chad Jacob Milios and Crop Circle Systems, Inc.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Simplified BSD License.
# If a copy of the Simplified BSD License was not distributed alongside this file, you can
# obtain one at https://www.freebsd.org/copyright/freebsd-license.html . This software
# project is not affiliated with the FreeBSD Project.
#
# Official updates and community support available at https://nuos.org .
# Other licensing options and professional services available at https://ccsys.com .

nuos_lib_ver=0.0.11.1a1
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -n "${nuos_lib_system_loaded-}" ]
[ -z "${nuos_lib_collection_loaded-}" ]
nuos_lib_collection_loaded=y

: ${HOSTOS_PKG_COLLECTION:=desktop}

collection_vars_init () {
	
	: ${PKG_COLLECTION:=$HOSTOS_PKG_COLLECTION}
	
	COLL_blank=
	
	COLL_bare='
		blank
		sysutils/pefs-kmod
		security/openssh-portable
		security/gnupg
		security/wpa_supplicant
		net/hostapd
		net/dhcpcd
		dns/unbound
	'
	
	COLL_lite='
		bare
		sysutils/screen
		misc/buffer
		sysutils/pipemeter
		archivers/lzop
		archivers/p7zip
		sysutils/pciutils
		sysutils/smartmontools
		net/rsync
		security/sudo
		textproc/jq
	'
	
	COLL_developer='
		lite
		devel/subversion
		devel/git
	'
	
	COLL_server='
		developer
		net-mgmt/lldpd
		mail/postfix
		mail/opendkim
		mail/opendmarc
		dns/knot2
		security/acme.sh
		net/openldap24-server
		security/openvpn
		ftp/pure-ftpd
		net/isc-dhcp43-server
		net/netatalk3
		net/samba46
		security/tor
		net-p2p/rtorrent
		net-p2p/bitcoin-daemon
		net-p2p/bitcoin-utils
		finance/vanitygen
		net-p2p/namecoin-stable-daemon
		net-p2p/namecoin-stable-utils
		net-p2p/litecoin-daemon
		net-p2p/litecoin-utils
		multimedia/ffmpeg
		graphics/optipng
		graphics/gifsicle
		lang/expect
		databases/postgresql96-server
		databases/mysql57-server
		databases/mongodb34
		databases/redis
		lang/mono-basic
		www/npm
		www/apache24
		www/nginx
		mail/cyrus-imapd25
		security/cyrus-sasl2-saslauthd
		net-im/ejabberd
		lang/phantomjs
		net/rabbitmq
		emulators/virtualbox-ose
		graphics/povray-meta
		graphics/graphviz
		x11-fonts/webfonts
		lang/php71-extensions
		www/mod_php71
		mail/roundcube-sieverules
		irc/irssi
		sysutils/lsof
		net/kamailio
	'
	
	COLL_office='
		server
		print/gutenprint
	'
	
	COLL_desktop='
		office
		editors/libreoffice
		graphics/gimp
		x11/xorg
		x11/kde4
		databases/virtuoso
		net-p2p/bitcoin
		net-p2p/namecoin-stable
		net-p2p/litecoin
		net-p2p/bitmessage
		net/x11vnc
		net/tightvnc
		www/firefox
		mail/thunderbird
		multimedia/vlc
		net-im/jitsi
	'
}
