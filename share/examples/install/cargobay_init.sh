domain=cargobay.net

ip_1=23.111.168.34 # willy
ip_2=66.206.20.42 # mama
ip_3=168.235.81.21 # iron
ip_4=168.235.71.47 # mcfly

case $NAME in
	willy)
		my_ip=$ip_1 # 23.111.168.34
		netmask=0xfffffff8
		defaultrouter=23.111.168.33
		primary_if=igb0
	;;
	mama)
		my_ip=$ip_2 # 66.206.20.42
		netmask=0xfffffff8
		defaultrouter=66.206.20.41
		primary_if=igb0
	;;
	iron)
		my_ip=$ip_3 # 168.235.81.21
		netmask=0xffffff00
		defaultrouter=168.235.81.1
	;;
	mcfly)
		my_ip=$ip_4 # 168.235.71.47
		netmask=0xffffff00
		defaultrouter=168.235.71.1
	;;
	*) die
esac

if canhas ${primary_if-}; then
	clear_primary_if_from_conf $TRGT/etc/rc.conf.local
fi

cat >> "$TRGT"/etc/rc.conf.local <<EOF
${primary_if:+ifconfig_${primary_if}_name="net0"
}ifconfig_net0="inet $my_ip netmask $netmask -rxcsum -rxcsum6 -txcsum -txcsum6 -lro -tso -vlanhwtso"
defaultrouter="$defaultrouter"
EOF

sed -i '' -E -e '/^#VersionAddendum\>/a\
ChallengeResponseAuthentication no\
PasswordAuthentication no\
AuthenticationMethods publickey,publickey,publickey
' "$TRGT"/usr/local/etc/ssh/sshd_config

sister enable_svc -C "$TRGT" ntpd openssh
#sister nu_ns_cache -C "$TRGT" -s

case $NAME in
	willy)
		##sister nu_ns_server -C $TRGT -d -k 4096 -z 2048 -i $ip_1 -i $ip_2 -i $ip_3 -i $ip_4 -s $ip_2 -s $ip_3 -s $ip_4
		#sister nu_ns_server -C $TRGT -d -k 4096 -z 2048 -i $ip_1 -i $ip_2 -s $ip_2
		cat >> "$TRGT"/etc/rc.conf.local <<EOF
ifconfig_net0_alias0="inet ${my_ip%.*}.$((${my_ip##*.}+1)) netmask 0xffffffff"
EOF
	;;
	*)
		##sister nu_ns_server -C $TRGT -i $ip_1 -i $ip_2 -i $ip_3 -i $ip_4 -m $ip_1
		#sister nu_ns_server -C $TRGT -i $ip_1 -i $ip_2 -m $ip_1
	;;
esac

sister enable_svc -C "$TRGT" nuos_firstboot
cp -v "$NUOS/share/examples/install/cargobay_genesis.sh" "$TRGT/root/"
echo 'nuos_firstboot_script="/root/cargobay_genesis.sh"' >> "$TRGT/etc/rc.conf.d/nuos_firstboot"
touch "$TRGT/firstboot"
