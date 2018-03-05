domain=cargobay.net

ip_1=23.111.168.34 # jack
ip_2=104.219.250.194 # chol
ip_3=168.235.81.21 # iron
ip_4=168.235.71.47 # mcfly

case $NAME in
	jack)
		my_ip=$ip_1 # 23.111.168.34
		netmask=0xfffffff8
		defaultrouter=23.111.168.33
		primary_if=igb0
	;;
	chol)
		my_ip=$ip_2 # 104.219.250.194
		netmask=0xffffff80
		defaultrouter=104.219.250.129
		primary_if=igb1
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

if [ -n "${primary_if-}" ]; then
	clear_primary_if_from_conf $TRGT/etc/rc.conf.local
fi

cat >> $TRGT/etc/rc.conf.local <<EOF
${primary_if:+ifconfig_${primary_if}_name="net0"
}ifconfig_net0="inet $my_ip netmask $netmask"
defaultrouter="$defaultrouter"
EOF

cat >> $TRGT/etc/sysctl.conf <<'EOF'
net.inet.tcp.recvbuf_inc=65536
net.inet.tcp.recvbuf_max=16777216
net.inet.tcp.recvspace=131072
net.inet.tcp.sendbuf_inc=65536
net.inet.tcp.sendbuf_max=16777216
net.inet.tcp.sendspace=131072
net.inet.tcp.cc.algorithm=htcp
net.inet.tcp.cc.htcp.adaptive_backoff=1
net.inet.tcp.cc.htcp.rtt_scaling=1
net.inet.tcp.mssdflt=1240
net.inet.tcp.minmss=536
net.inet.tcp.rfc6675_pipe=1
net.inet.tcp.syncache.rexmtlimit=0
net.inet.ip.maxfragpackets=0
net.inet.ip.maxfragsperpacket=0
net.inet.tcp.abc_l_var=44
net.inet.tcp.initcwnd_segments=44
EOF

sed -i '' -E -e '/^#VersionAddendum\>/a\
ChallengeResponseAuthentication no\
PasswordAuthentication no\
AuthenticationMethods publickey,publickey,publickey
' $TRGT/usr/local/etc/ssh/sshd_config

sister enable_svc -C $TRGT ntpd
sister enable_svc -C $TRGT openssh
sister nu_ns_cache -C $TRGT -s

case $NAME in
	jack)
		#sister nu_ns_server ${POOL_MNT:+-C $POOL_MNT} -d -k 4096 -z 2048 -i $ip_1 -i $ip_2 -i $ip_3 -i $ip_4 -s $ip_2 -s $ip_3 -s $ip_4
		sister nu_ns_server ${POOL_MNT:+-C $POOL_MNT} -d -k 4096 -z 2048 -i $ip_1 -i $ip_2 -s $ip_2
	;;
	*)
		#sister nu_ns_server ${POOL_MNT:+-C $POOL_MNT} -i $ip_1 -i $ip_2 -i $ip_3 -i $ip_4 -m $ip_1
		sister nu_ns_server ${POOL_MNT:+-C $POOL_MNT} -i $ip_1 -i $ip_2 -m $ip_1
	;;
esac
