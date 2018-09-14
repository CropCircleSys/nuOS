#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.2a1 - lib/nu_collection.sh
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

nuos_lib_ver=0.0.11.2a1
[ $nuos_lib_ver = "$NUOS_VER" ]
[ -n "${nuos_lib_system_loaded-}" ]
[ -z "${nuos_lib_collection_loaded-}" ]
nuos_lib_collection_loaded=y

: ${HOSTOS_PKG_COLLECTION:=desktop}

reset_pkg_collection () {
	: ${PKG_COLLECTION:=$HOSTOS_PKG_COLLECTION}
	
	local src_ver="${BASEOS_TYPE}-${BASEOS_VER}"
	local host_base_ver="`uname -s`-`uname -r`"
	
	if [ ${src_ver%-p*} != ${host_base_ver%-p*} ]; then
		PKG_COLLECTION=blank
	fi
	if [ -q != "${1-}" ]; then
		echo 'pkg collection  -c PKG_COLLECTION ' $PKG_COLLECTION
	fi
}

collection_vars_init () {
	
	reset_pkg_collection ${1-}
	
	COLL_blank=
	
	COLL_pkg=ports-mgmt/pkg
	
	COLL_bare='
		pkg
		net/ipxe
		net/isboot-kmod
		sysutils/pefs-kmod
		security/openssh-portable
		security/wpa_supplicant
		net/hostapd
		net/dhcpcd
		dns/unbound
	'

	COLL_base='
		bare
		security/gnupg
	'

	COLL_lite='
		base
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
		net/mpd5
		ftp/pure-ftpd
		net/isc-dhcp44-server
		net/istgt
		net/netatalk3
		net/samba48
		security/tor
		net-p2p/rtorrent
		net-p2p/createtorrent
		net-p2p/bitcoin-daemon
		net-p2p/bitcoin-utils
		finance/vanitygen
		net-p2p/namecoin-daemon
		net-p2p/namecoin-utils
		net-p2p/litecoin-daemon
		net-p2p/litecoin-utils
		net-p2p/monero-cli
		multimedia/ffmpeg
		www/youtube_dl
		graphics/optipng
		graphics/gifsicle
		lang/expect
		databases/postgresql10-server
		databases/mysql57-server
		databases/mongodb36
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
		sysutils/vmdktool
		graphics/povray-meta
		graphics/graphviz
		x11-fonts/webfonts
		lang/php72-extensions
		www/mod_php72
		mail/roundcube-sieverules
		irc/irssi
		sysutils/lsof
		net/kamailio
		sysutils/ipfs-go
		lang/go
		print/gutenprint
		print/fontforge
	'
	
	COLL_desktop='
		server
		editors/libreoffice
		graphics/gimp
		graphics/inkscape
		x11/xorg
		x11/kde5
		x11/sddm
		net-p2p/bitcoin
		net-p2p/namecoin
		net-p2p/litecoin
		net-p2p/bitmessage
		net/x11vnc
		net/tightvnc
		www/firefox
		java/icedtea-web
		mail/thunderbird
		multimedia/vlc
		net-im/jitsi
		graphics/appleseed
		graphics/luxrender
		graphics/blender
		games/sdlpop
	'
}
