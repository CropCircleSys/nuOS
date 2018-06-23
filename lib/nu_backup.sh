#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.2a1 - lib/nu_backup.sh
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
[ -z "${nuos_lib_backup_loaded-}" ]
nuos_lib_backup_loaded=y

ds_mnt_info () {
	local ds=$1
	mntd=`zfs get -H -p -o value mounted $ds`
	mnt_pt=`zfs get -H -p -o value mountpoint $ds`
	mnt_src=`zfs get -H -p -o source mountpoint $ds`
	can_mnt=`zfs get -H -p -o value canmount $ds`
	can_src=`zfs get -H -p -o source canmount $ds`
	echo "${0##*/}.zfs_ds_mount	$mntd	$mnt_pt	$mnt_src	$can_mnt	$can_src"
}
