#!/usr/bin/false
set -e; set -u; set -C

# nuOS 0.0.11.4a0 - lib/nu_admin.sh
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
[ -z "${nuos_lib_admin_loaded-}" ]
nuos_lib_admin_loaded=y

admin_init () {
	# OEM Default admin user/pass. Definitely change/disable this.
	echo 'admin           -a ADMIN_ACCT     ' ${ADMIN_ACCT=ninja}
	: ${KEYS_FROM_ADMIN_ACCT:=$ADMIN_ACCT}
	echo -n 'admin pass         ADMIN_PASS      ' && [ -n "${ADMIN_ACCT-}" ] && echo ${ADMIN_PASS=nutz} || echo n/a
	echo -n 'admin name         ADMIN_NAME      ' && [ -n "${ADMIN_ACCT-}" ] && echo ${ADMIN_NAME:="Code Ninja"} || echo n/a
	echo -n 'admin company      ADMIN_CPNY      ' && [ -n "${ADMIN_ACCT-}" ] && echo ${ADMIN_CPNY:="Whey of Peas and Hominy"} || echo n/a # N/I
	echo -n 'admin keys         ADMIN_KEYS      ' && [ -n "${ADMIN_ACCT-}" -a -n "${OPT_INSTALL_ADMIN_KEYS-}" ] && echo ${ADMIN_KEYS:=~$KEYS_FROM_ADMIN_ACCT/.ssh/id_*.pub} && echo "WARNING - Expands to: `eval echo $ADMIN_KEYS`" || echo 'n/a (use -k to install keys)'
	# OEM Default user/pass. Change this.
	echo 'user            -u USER_ACCT      ' ${USER_ACCT=joe}
	: ${KEYS_FROM_USER_ACCT:=$USER_ACCT}
	echo -n 'user pass          USER_PASS       ' && [ -n "${USER_ACCT-}" ] && echo ${USER_PASS=mama} || echo n/a
	echo -n 'user name          USER_NAME       ' && [ -n "${USER_ACCT-}" ] && echo ${USER_NAME:="Joe Schmoe"} || echo n/a
	echo -n 'user company       USER_CPNY       ' && [ -n "${USER_ACCT-}" ] && echo ${USER_CPNY:="Schmoe 'n' Co., Inc."} || echo n/a # N/I
	echo -n 'user keys          USER_KEYS       ' && [ -n "${USER_ACCT-}" -a -n "${OPT_INSTALL_ADMIN_KEYS-}" ] && echo ${USER_KEYS:=~$KEYS_FROM_USER_ACCT/.ssh/id_*.pub} && echo "WARNING - Expands to: `eval echo $USER_KEYS`" || echo 'n/a (use -k to install keys)'
	# VAR Default backdoor. Change/disable this this.
	echo 'backdoor user   -b BD_ACCT        ' ${BD_ACCT=sumyungai}
	: ${KEYS_FROM_BD_ACCT:=$BD_ACCT}
	echo -n 'backdoor pass      BD_PASS         ' && [ -n "${BD_ACCT-}" ] && echo ${BD_PASS=_-cream0f-_} || echo n/a
	echo -n 'backdoor name      BD_NAME         ' && [ -n "${BD_ACCT-}" ] && echo ${BD_NAME:="Sum Yun Gai"} || echo n/a
	echo -n 'backdoor company   BD_CPNY         ' && [ -n "${BD_ACCT-}" ] && echo ${BD_CPNY:="In Yer Eye, L.L.C."} || echo n/a # N/I
	echo -n 'backdoor keys      BD_KEYS         ' && [ -n "${BD_ACCT-}" -a -n "${OPT_INSTALL_ADMIN_KEYS-}" ] && echo ${BD_KEYS:=~$KEYS_FROM_BD_ACCT/.ssh/id_*.pub} && echo "WARNING - Expands to: `eval echo $BD_KEYS`" || echo 'n/a (use -k to install keys)'
}

admin_install () {
	local opt_zfs_create=
	if [ x-z = x$1 ]; then
		opt_zfs_create=y
		shift
	fi		
	local trgt_path=$1

	key_install () {
		local acct=$1 keys=$2
		for key in `eval echo $keys`; do
			key="${key%.pub}.pub"
			if [ -f $key ]; then
				local home=
				echo "WARNING: authorizing key '$key' to connect as user '$acct'" >&2
				: ${home:=`chroot "$trgt_path" pw usershow -n $acct | cut -d : -f 9`}
				if [ ! -d "$trgt_path$home/.ssh" ]; then
					(umask 77 && mkdir "$trgt_path$home/.ssh")
					chroot "$trgt_path" chown $acct "$home/.ssh"
				fi
				if [ ! -f "$trgt_path$home/.ssh/authorized_keys" ]; then
					:> "$trgt_path$home/.ssh/authorized_keys"
					chroot "$trgt_path" chown $acct "$home/.ssh/authorized_keys"
				fi
				cat "$key" >> "$trgt_path$home/.ssh/authorized_keys"
			fi
		done
	}

	key_copy () {
		local acct=$1 keys_from_acct=$2
		local from_file=`eval echo ~$keys_from_acct/.ssh/authorized_keys`
		if [ -n "$keys_from_acct" ] && [ -f $from_file ]; then
			for user in ${ALSO_INSTALL_KEYS-}; do
				local num_keys_found=`grep -E -i "\b$user\$" $from_file | wc -l | xargs`;
				if [ $num_keys_found -ge 1 ]; then
					echo "WARNING: authorizing $num_keys_found keys belonging to $user found in ~$keys_from_acct to connect as user '$acct'" >&2
					: ${home:=`chroot "$trgt_path" pw usershow -n $acct | cut -d : -f 9`}
					if [ ! -d "$trgt_path$home/.ssh" ]; then
						(umask 77 && mkdir "$trgt_path$home/.ssh")
						chroot "$trgt_path" chown $acct "$home/.ssh"
					fi
					if [ ! -f "$trgt_path$home/.ssh/authorized_keys" ]; then
						:> "$trgt_path$home/.ssh/authorized_keys"
						chroot "$trgt_path" chown $acct "$home/.ssh/authorized_keys"
					fi
					grep -E -i "\b$user\$" $from_file >> "$trgt_path$home/.ssh/authorized_keys"
				fi
			done
		fi
	}

	acct_install () {
		local opt_zfs_create= user_home_fresh= user_home_existed=
		if [ x-z = x$1 ]; then
			opt_zfs_create=y
			shift
		fi
		local acct=$1 pass="$2" name="${3-}" cpny="${4-}" keys="${5-}" keys_from_acct="${6-}" useradd_flags="${7-}" groupadd_flags="${8-}"
		if [ -n "$acct" ]; then
			echo "WARNING: creating account '$acct' inside new system" >&2
			if [ -n "$opt_zfs_create" ]; then
				if zfs create $POOL_NAME/home/$acct; then
					user_home_fresh=y
					if [ -n "${home_existed-}" -a -n "$alt_mnt" ]; then
						mount -t nullfs /home/$acct "$alt_mnt/home/$acct" 
					fi
				else
					[ -n "${home_existed-}" ]
					user_home_existed=y
					if [ no = `zfs get -H -o value mounted $POOL_NAME/home/$acct` ]; then
						if [ -n "$alt_mnt" ]; then
							mount -t zfs $POOL_NAME/home/$acct "$alt_mnt/home/$acct"
						else
							zfs mount $POOL_NAME/home/$acct
						fi
					fi
				fi
			else
				if mkdir "$trgt_path/home" || [ ! -d "$trgt_path/home/$acct" ]; then
					user_home_fresh=y
				else
					user_home_existed=y
				fi
			fi
			
			chroot "$trgt_path" pw groupadd -n $acct $groupadd_flags
			
			if [ -n "$pass" ]; then
				chroot "$trgt_path" pw useradd ${user_home_fresh:+-m} -n $acct -g $acct -c "$name" $useradd_flags -h 0 <<EOF
$pass
EOF
			else
				chroot "$trgt_path" pw useradd ${user_home_fresh:+-m} -n $acct -g $acct -c "$name" $useradd_flags
			fi
			if [ -n "${OPT_INSTALL_ADMIN_KEYS-}" ]; then
				key_install $acct "$keys"
			fi
			if [ -n "${ALSO_INSTALL_KEYS-}" ]; then
				key_copy $acct "$keys_from_acct"
			fi
		fi
	}

	acct_install "$BD_ACCT" "${BD_PASS-}" "${BD_NAME-}" "${BD_CPNY-}" "${BD_KEYS-}" "$KEYS_FROM_BD_ACCT" "-u 1000 -G wheel -d /var/bd -s csh" "-g 1000"
	acct_install ${opt_zfs_create:+-z} "$ADMIN_ACCT" "${ADMIN_PASS-}" "${ADMIN_NAME-}" "${ADMIN_CPNY-}" "${ADMIN_KEYS-}" "$KEYS_FROM_ADMIN_ACCT" "-G wheel -s csh"
	acct_install ${opt_zfs_create:+-z} "$USER_ACCT" "${USER_PASS-}" "${USER_NAME-}" "${USER_CPNY-}" "${USER_KEYS-}" "$KEYS_FROM_USER_ACCT"
}
