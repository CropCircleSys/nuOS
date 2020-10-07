sister nu_ns_cache -C "$TRGT" -s
sister enable_svc -C "$TRGT" openssh ntpd dhcpcd dbus avahi_daemon netatalk

sed -Ee 's/^\+(afp interfaces)/+;\1/' "$NUOS"/share/examples/etc/afp.conf.diff | patch "$TRGT"/usr/local/etc/afp.conf

cat >> "$TRGT"/usr/local/etc/dhcpcd.conf <<'EOF'

# Ignore VPN interfaces
denyinterfaces tap[0-9]* tun[0-9]* ng[0-9]* epair[0-9]*[ab]
EOF

cp "$NUOS"/share/examples/etc/dhcpcd.exit-hook "$TRGT"/usr/local/etc/
