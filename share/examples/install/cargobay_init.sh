domain=cargobay.net

case $NAME in
	willy)
		my_ip=23.111.168.34
		netmask=0xfffffff8
		defaultrouter=23.111.168.33
		primary_if=igb0
	;;
	mama)
		my_ip=66.206.20.42
		netmask=0xfffffff8
		defaultrouter=66.206.20.41
		primary_if=igb0
	;;
	iron)
		my_ip=168.235.81.21
		netmask=0xffffff00
		defaultrouter=168.235.81.1
	;;
	mcfly)
		my_ip=168.235.71.47
		netmask=0xffffff00
		defaultrouter=168.235.71.1
	;;
	*) die
esac

if canhas ${primary_if-}; then
	set_primary_phys_netif $primary_if "$TRGT"
fi

cat >> "$TRGT/etc/rc.conf.local" <<EOF
ifconfig_net0="inet $my_ip netmask $netmask -rxcsum -rxcsum6 -txcsum -txcsum6 -lro -tso -vlanhwtso"
defaultrouter="$defaultrouter"
EOF

sed -i '' -E -e '/^#VersionAddendum\>/a\
ChallengeResponseAuthentication no\
PasswordAuthentication no\
AuthenticationMethods publickey,publickey,publickey
' "$TRGT/usr/local/etc/ssh/sshd_config"

sister enable_svc -C "$TRGT" ntpd openssh

case $NAME in
	willy|mama)
		cat >> "$TRGT/etc/rc.conf.local" <<EOF
ifconfig_net0_alias0="inet `next_ip $my_ip` netmask 0xffffffff"
EOF
		cp -v "$NUOS/share/examples/install/cargobay_genesis.sh" "$TRGT/root/"
		echo 'nuos_firstboot_script="/root/cargobay_genesis.sh"' > "$TRGT/etc/rc.conf.d/nuos_firstboot"
	;;
	*)
		:
esac

sister enable_svc -C "$TRGT" nuos_firstboot
touch "$TRGT/firstboot"
