# This is an internal identifier for this dynamic system.
fleet=cargobay

# These represent the associations of users provided for by this fleet. All users know of all flags running on the fleet. In order to become visible a user must associate with a flag globally within the fleet (for covert flags) or universally within the federation (for flown flags).
flags='ccsys nuos'

# These vaguely encompass social forces or functions the system provides or purposes the system serves for its users. The system should not reveal to any user the winds affecting or used by other users.
winds='breathe holler roar whisper'

# These vaguely encompass jurisdictional societies.
skys='soaring.baldeagle wounded.baldeagle davyjones locker'

# These end up being domain labels for hostnames used by the fleet.
seas='det.us lax.us phx.us tpa.us ca de jp ca.se.flood us.se.flood nw.us.ms.thunder gl.rain az.drizzle se.us.rn.mist ne.us.do.poof de.do.poof'

sands='cave castle hill'

cave_admiral=jedi
cave_vessels='yoda r2d2 c3po vader'

castle_admiral=boba
castle_vessels='jack chol iron mcfly'

for sand in $sands; do
	load $sand vessels
	load $sand admiral

	case $sand in
		cave)
			local_script=activate_gui
		;;
		castle)
			stage_source=yoda
			source_admiral=$cave_admiral
			local_script=cargobay_init
		;;
		hill)
			local_script=
		;;
		*) die
	esac

	for vessel in $vessels; do
		case $vessel in
			jack|chol|mcfly)
				host=$vessel.ccsys.com;;
			yoda|r2d2|c3po|vader)
				host=$vessel.cropcircle.systems;;
			iron)
				host=$vessel.yearbookproject.net;;
			*) die
		esac
		case $vessel in
			yoda)
				source_admiral=ninja
				stage_source=beast
				local_boot_size=500G
				swap_size=24G
			;;
			r2d2)
				source_admiral=jedi
				stage_source=yoda
				#local_boot_size=122368M
				local_boot_size=61504M
				swap_size=2G
			;;
			c3po)
				source_admiral=jedi
				stage_source=yoda
				local_boot_size=78125000K
				swap_size=2G
			;;
			jack)
				local_boot_size=468851544K
				swap_size=48G
			;;
			chol)
				local_boot_size=468851544K
				swap_size=16G
			;;
			iron)
				local_boot_size=90G
				swap_size=2G
			;;
			mcfly)
				local_boot_size=20G
				swap_size=1G
			;;
			*) die
		esac

		if [ $vessel = $POOL ]; then
# 			bootstrap_pool=beast
# 			bootstrap_img_size=61504M
# 			echo zfs create -o compression=off -o checksum=off -V $bootstrap_img_size -b 64K -s $POOL/$bootstrap_pool
# 			echo env ADMIN_PASS= KEYS_FROM_ADMIN_ACCT=${USER:-ninja} nu_install -t '' -d zvol/$POOL/$bootstrap_pool -FDD -c blank -p $bootstrap_pool -u '' -b '' -k
			continue
		fi

		echo zfs create -o compression=off -o checksum=off -V $local_boot_size -b 64K -s $stage_source/$vessel
		echo env ADMIN_PASS= KEYS_FROM_ADMIN_ACCT=$source_admiral nu_install -t '' -d zvol/$stage_source/$vessel -s $swap_size -c desktop -p $vessel -h $host -a $admiral -u '' -b '' -k -l "$(dirname "$(realpath "$0")")/../share/install/$local_script.sh"
	done

done
