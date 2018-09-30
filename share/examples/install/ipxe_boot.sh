cat >> "$TRGT"/boot/loader.conf.local <<'EOF'
isboot_load="YES"
EOF

# Disable all firewall
sed -i '' -Ee '/^firewall_/s/^/#/;/^kld_list=/{s/ ?ipfw//;s/$/ # -ipfw/;}' "$TRGT"/etc/rc.conf
