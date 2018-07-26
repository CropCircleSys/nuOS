nu_ns_cache -C "$TRGT" -s
enable_svc -C "$TRGT" openssh ntpd dhcpcd dbus avahi_daemon netatalk
sed -Ee 's/^\+(afp interfaces)/+;\1/' "$NUOS"/share/examples/etc/afp.conf.diff | patch "$TRGT"/usr/local/etc/afp.conf
cp "$NUOS"/share/examples/etc/dhcpcd.exit-hook "$TRGT"/usr/local/etc/
