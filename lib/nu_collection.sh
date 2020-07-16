#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.4a0 - lib/nu_collection.sh
#
# Copyright (c) 2008-2020 Chad Jacob Milios and Crop Circle Systems.
# All rights reserved.
#
# This Source Code Form is subject to the terms of the Simplified BSD License.
# If a copy of the Simplified BSD License was not distributed alongside this file, you can
# obtain one at https://www.freebsd.org/copyright/freebsd-license.html . This software
# project is not affiliated with the FreeBSD Project.
#
# Official updates and community support available at https://nuos.org .
# Professional services available at https://ccsys.com .

nuos_lib_ver=0.0.11.4a0
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
	
	COLL_pkg='
		blank
		ports-mgmt/pkg
	'
	
	COLL_bare='
		pkg
		net/ipxe
		net/isboot-kmod
		sysutils/pefs-kmod
		security/openssh-portable@hpn
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
		archivers/p7zip-codec-rar
		sysutils/pciutils
		sysutils/dmidecode
		sysutils/smartmontools
		net/rsync
		security/sudo
		sysutils/lsof
		textproc/jq
	'
	
	COLL_developer='
		lite
		devel/subversion
		devel/git
		devel/mercurial
		lang/gawk
		textproc/gsed
		devel/gmake
		sysutils/coreutils
		lang/expect
		math/convertall
	'
	
	COLL_user='
		lite
		finance/ledger
		irc/irssi
		net-im/tut
	'
	
	COLL_miniserver='
		developer
		user
		net-mgmt/lldpd
		mail/postfix
		mail/opendkim
		mail/opendmarc
		dns/knot2
		security/acme.sh
		net/openldap24-server
		security/openvpn
		net/mpd5
		net/avahi
		dns/nss_mdns
		net/3proxy
		ftp/pure-ftpd
		net/isc-dhcp44-server
		net/istgt
		net/mosquitto
		mail/cyrus-imapd32
		security/cyrus-sasl2-saslauthd
		databases/postgresql12-server
		databases/mysql57-server
		databases/mongodb42
		databases/redis
		lang/mono-basic
		lang/go
		www/npm
		lang/php74-extensions
		graphics/pecl-imagick-im7
		www/mod_php74
		www/apache24
		www/nginx
		net/haproxy
		net-im/ejabberd
		net/rabbitmq
		lang/erlang-runtime22
		lang/elixir
		net/kamailio
		sysutils/ipfs-go
		security/tor
		net-im/py-matrix-synapse
	'
	
	COLL_mediaserver='
		miniserver
		www/httrack
		net/netatalk3
		net/samba411
		multimedia/ffmpeg
		multimedia/Bento4
		www/youtube_dl
		www/annie
		net-p2p/rtorrent
		net-p2p/createtorrent
		net-p2p/torrentcheck
	'
	
	COLL_coinserver='
		miniserver
		net-p2p/bitcoin-daemon
		net-p2p/bitcoin-utils
		net-p2p/litecoin-daemon
		net-p2p/litecoin-utils
		net-p2p/namecoin-daemon
		net-p2p/namecoin-utils
		net-p2p/monero-cli
	'
	
	COLL_commonserver='
		mediaserver
		coinserver
	'
	
	COLL_server='
		commonserver
		graphics/optipng
		graphics/gifsicle
		lang/phantomjs
		emulators/virtualbox-ose
		sysutils/vmdktool
		graphics/povray-meta
		graphics/graphviz
		x11-fonts/webfonts
		mail/roundcube-sieverules
		print/gutenprint
		print/fontforge
	'
	
	COLL_desktop='
		server
		editors/libreoffice
		graphics/gimp
		graphics/krita
		graphics/inkscape
		audio/audacity
		audio/muse-sequencer
		print/scribus-devel
		x11/xorg
		x11/kde5
		x11/sddm
		net-p2p/bitcoin
		net-p2p/litecoin
		net-p2p/namecoin
		net/x11vnc
		net/tightvnc
		www/firefox
		java/icedtea-web
		mail/thunderbird
		multimedia/vlc
		multimedia/obs-studio
		multimedia/obs-ndi
		multimedia/obs-websocket
		multimedia/obs-scrab
		multimedia/wlrobs
		multimedia/obs-v4l2sink
		multimedia/obs-transition-matrix
		multimedia/obs-streamfx
		multimedia/obs-qtwebkit
		multimedia/shotcut
		net-im/jitsi
		graphics/blender
		games/sdlpop
	'
	
	COLL_nice='
		server
		lang/v
		security/palisade
		math/fplll
		math/maxima
	'
	
	COLL_nasty='
		nice
		desktop
		finance/gnucash
		finance/kmymoney
		finance/jgnash
		math/sage
		audio/protracker
		audio/fasttracker2
		audio/mixxx
	'
}
