mikey_ip=23.111.168.34
mouth_ip=23.111.168.35
data_ip=23.111.168.36
chunk_ip=23.111.168.37
brand_ip=23.111.168.38

jake_ip=66.206.20.42
francis_ip=66.206.20.43
sloth_ip=66.206.20.44
andy_ip=66.206.20.45
stef_ip=66.206.20.46

case `hostname -d | tr [[:upper:]] [[:lower:]]` in
	
	cargobay.net|ccsys.com|cropcircle.systems)
		
		# This must be two characters. (standard: ISO 3166-1 alpha-2; e.g. blank is XX)
		country=US
		
		# These must be defined, but they can be the empty string.
		province='Florida'
		locality='Kissimmee'
		organization='Crop Circle Systems'
		
		OWNER_ACCT=chuck
		OWNER_NAME='Charles Jacob Milios'
		
		primary_ip=$mikey_ip
		secondary_ip=$mouth_ip
		
		infra_domain=cargobay.net
		corp_zones='ccsys.com cropcircle.systems'
		org_zones='nuos.net nuos.org nu.cash nu.chat nu.click nu.email nu.gold nu.live nu.lol nu.money nu.parts nu.place nu.school nu.show nu.software nu.team nu.zone'
		prod_zones='uhax.tv pawn.today freer.trade xng.trade xchng.trade unblind.date blindish.date bemylil.baby dollhouse.cam wifeknows.best dadsmore.fun daddy.bar dads.wtf dad.university man.coach faith.agency'
		
		sec_dept='System & Network Security'
		net_dept='Network Infrastructure & Operations'
		
		init_emails='chad@ccsys.com milios@ccsys.com *@ccsys.com chuck@nu.email chad@nu.email jake@nu.email'
	;;
	
	woneye.site|uglybagsofmostlywater.club)
		
		country=US
		
		province='Oregon'
		locality='Astoria'
		organization='Lighthouse Lounge'
		
		OWNER_ACCT=anne
		OWNER_NAME='Angelina Fratelli'
		
		primary_ip=$jake_ip
		secondary_ip=$francis_ip
		
		infra_domain=woneye.site
		corp_zones='uglybagsofmostlywater.club'
		org_zones='nuos.xyz'
		
		sec_dept='Development & Production Quality Assurance'
		net_dept='Architecture Quality Assurance'
		
		init_emails='willy@woneye.site giant@uglybagsofmostlywater.club'
	;;
	
	entire.ninja)
		
		country=QU
		
		province='Hi no Kuni'
		locality='Konohagakure'
		organization='Foundation'
		
		OWNER_ACCT=naruto
		OWNER_NAME='Naruto Uzumaki'
		
		primary_ip=$chunk_ip
		secondary_ip=$brand_ip
		
		infra_domain=entire.ninja
		
		sec_dept='Advanced Network & System Operations'
		net_dept='Advanced System Engineering'
		
		init_emails='naruto@entire.ninja hokage@entire.ninja jonin@entire.ninja'
	;;
	
	macleod.host|goonies.pro)
		
		country=UK
		
		# These must be defined, but they can be the empty string.
		province='Scotland'
		locality='Glenfinnan'
		organization='Russell Nash Antiques & Curiosities'
		
		OWNER_ACCT=one
		OWNER_NAME='Connor MacLeod'
		
		primary_ip=$andy_ip
		secondary_ip=$stef_ip
		
		infra_domain=macleod.host
		corp_zones='goon.store goonies.pro'
		org_zones='gangsta.tech thug.digital bully.ninja'
		prod_zones='emptier.space bravest.world'
		
		sec_dept='Infrastructure & Operations Quality Assurance'
		net_dept='System Engineering Quality Assurance'
		
		init_emails='connor@macleod.host one@bravest.world zero@emptier.space mikey@goonies.pro mouth@goonies.pro data@goonies.pro chunk@goonies.pro brand@goonies.pro stef@goonies.pro andy@goonies.pro mama@goon.store jake@goon.store francis@goon.store sloth@goon.store'
	;;
	*)
		echo "ERROR: unsure of identity and ownership, check configuration" >&2
		exit 1
esac

client_zones="$corp_zones $org_zones $prod_zones"

echo infra_domain=$infra_domain
echo client_zones=$client_zones
env

enable_svc jail

nu_jail -j resolv -S domain -T a.ns -T b.ns -x -q -i 127.1.0.1
nu_ns_cache -C /var/jail/resolv -s
{ grep -w -v nameserver /var/jail/resolv/etc/resolv.conf; getent hosts resolv.jail | cut -w -f 1 | xargs -n 1 echo nameserver; } > /etc/resolv.conf
cp -av /var/jail/resolv/etc/resolvconf.conf /etc/resolvconf.conf

nu_jail -j ns -S domain -x -q -i 127.1.0.2
env ALIAS_IP=$primary_ip nu_jail -j a.ns -i 127.1.0.3 -AP -S domain -x -q
env ALIAS_IP=$secondary_ip nu_jail -j b.ns -i 127.1.0.4 -AP -S domain -x -q
nu_ns_server -C /var/jail/ns -d -k 4096 -z 2048 -i $primary_ip -i $secondary_ip -s a.ns.jail -s b.ns.jail
nu_ns_server -C /var/jail/a.ns -i $primary_ip -i $secondary_ip -m ns.jail
nu_ns_server -C /var/jail/b.ns -i $primary_ip -i $secondary_ip -m ns.jail
if [ -d /root/nuos_deliverance/ns ]; then
	tar -cf - -C /root/nuos_deliverance/ns/knotdb keys | tar -xvf - -C /var/jail/ns/var/db/knot
fi
service jail start resolv ns a.ns b.ns
for z in $infra_domain $client_zones; do
	for j in ns a.ns b.ns; do
		nu_ns_host -j $j -h $z
	done
	nu_sshfp -j ns -F -h $z
done

echo
for z in $infra_domain $client_zones; do
	nu_ns_host -j ns -h $z -k
done

echo
echo Sleeping three minutes to allow canonical DNS authority to be established
sleep 180 &
p=$!
echo "(kill -STOP $p; kill -CONT $p) to pause and resume"
wait $p

for s in lb vpn ca; do
	if [ -d /root/nuos_deliverance/$s ]; then
		tar -cf - -C /root/nuos_deliverance/$s/ssl . | tar -xvf - -C /etc/ssl
	fi
done

if [ ! -f /etc/ssl/private/ca.$infra_domain.key ] || [ ! -f /etc/ssl/certs/ca.$infra_domain.internal.crt ]; then
	nu_ssl -h ca.$infra_domain -b 4096 -s -W -d 512 -n $country -p "$province" -l "$locality" -o "$organization" -u "$sec_dept" -S
fi
if [ ! -f /etc/ssl/private/$infra_domain.key ] || [ ! -f /etc/ssl/csrs/$infra_domain.csr ]; then
	nu_ssl -h $infra_domain -b 4096 -n $country -p "$province" -l "$locality" -o "$organization" -u "$net_dept" -S
fi
if [ ! -f /etc/ssl/certs/$infra_domain.internal.crt ]; then
	nu_ca -h $infra_domain
fi
nu_vpn -q -h $infra_domain
service openvpn start

if [ ! -f /etc/ssl/csrs.next/$infra_domain.csr ]; then
	nu_ssl -h $infra_domain -b 4096 -n $country -p "$province" -l "$locality" -o "$organization" -u "$net_dept" -S -N
fi
nu_acme_renew -j ns $infra_domain
nu_ssl -j ns -F -h $infra_domain -tt

nu_jail -j postmaster -i 127.1.0.5 -P -S smtp -I submission -x -q
(cd /etc/ssl && tar -cf - certs/$infra_domain.ca.crt certs/$infra_domain.crt csrs.next/$infra_domain.csr csrs/$infra_domain.csr private/$infra_domain.key | tar -xvf - -C /var/jail/postmaster/etc/ssl/)
mkdir -p /var/jail/postmaster/var/imap/socket
service jail start postmaster
nu_smtp -j postmaster -s -e -h $infra_domain

nu_jail -j postoffice -i 127.1.0.6 -m -P -I imap -I imaps -I pop3 -I pop3s -I sieve -x -q
(cd /etc/ssl && tar -cf - certs/$infra_domain.ca.crt certs/$infra_domain.crt csrs.next/cargobay.net.csr csrs/$infra_domain.csr private/$infra_domain.key | tar -xvf - -C /var/jail/postoffice/etc/ssl/)
service jail start postoffice
nu_imap -j postoffice -s -e -h $infra_domain
while read -r proto procs; do
	prgm="${prgm-}${prgm:+ }/#?[[:blank:]]$proto\\>/s/\\<(prefork)=[[:digit:]]+/\1=$procs/;"
done <<'EOF'
imap 8
imaps 2
lmtp(unix)? 1
EOF
sed -i '' -E -e "/^SERVICES {/,/^}/{$prgm}" /var/jail/postoffice/usr/local/etc/cyrus.conf
echo /var/jail/postoffice/var/imap/socket /var/jail/postmaster/var/imap/socket nullfs ro > /etc/fstab.postoffice
if [ -d /root/nuos_deliverance/po ]; then
	tar -cf - -C /root/nuos_deliverance/po . | tar -xvf - -C /var/jail/postoffice/var
fi

service jail restart postmaster postoffice

nu_user -C /var/jail/postmaster -h $infra_domain -a -d net -u $OWNER_ACCT -n "$OWNER_NAME" < /root/owner_pass
nu_user -C /var/jail/postoffice -h $infra_domain -a -u $OWNER_ACCT -n "$OWNER_NAME" < /root/owner_pass
for z in $infra_domain $client_zones; do
	nu_smtp_host -C /var/jail/postmaster -h $z
	for b in operator security hostmaster postmaster whois-data; do
		nu_user_mail -C /var/jail/postmaster -h $infra_domain -u $OWNER_ACCT -m $b@$z
	done
done
for m in $init_emails; do
	nu_user_mail -C /var/jail/postmaster -h $infra_domain -u $OWNER_ACCT -m $m
done

for z in $client_zones; do
	(
		case $z in
			cropcircle.systems)
				department='Customer Service';;
			ccsys.com)
				department='Sales and Customer Support';;
			nuos.org)
				department='Next Underground Operating System';;
			nuos.net)
				department='National Union Organizational Society';;
			nu.zone)
				department='Identity & Authority Registration';;
			nu.software)
				department='Universal Software Distribution Center';;
			nu.place)
				department='Secure Site-Specific Storage Service';;
			nu.email)
				department='Secure Electronic Post Office';;
			nu.chat)
				department='Realtime Private Communication';;
			nu.team)
				department='Collaborative Resource Management';;
			nu.show)
				department='Interactive Media Presentation';;
			nu.live)
				department='Realtime Media Distribution';;
			nu.lol)
				department='Social Media Chronology & Archival';;
			nu.click)
				department='Advertising and Trend Analysis';;
			nu.parts)
				department='Construction and Manufacturing';;
			nu.school)
				department='Knowledge Library and Training Academy';;
			nu.money)
				department='Cryptographic Instrument Issuance & Offering Service';;
			nu.gold)
				department='Cryptographic Assets and Democratic Service';;
			nu.cash)
				department='Cryptographic Monetary Products';;
			uglybagsofmostlywater.club)
				department='Cordial Community Contributor Coterie Clan';;
			nuos.xyz)
				department='Advanced Software Research & Development';;
			gangsta.tech)
				department='Advanced Software Architecture';;
			bully.ninja)
				department='Advanced Software Engineering';;
			thug.digital)
				department='Advanced Software Production';;
			goonies.pro)
				department='Faux Customer Service';;
			goon.store)
				department='Faux Sales & Customer Support';;
			emptier.space)
				department='Testbed System Host Service';;
			bravest.world)
				department='Testbed Application Service';;
			uhax.tv)
				department='Hacker News and Entertainment';;
			pawn.today)
				department='Collateralized Lending Market Portal';;
			freer.trade)
				department='Community Goods & Services Market Portal';;
			xng.trade|xchng.trade)
				department='Cryptographic Instrument Market Portal';;
			blindish.date)
				department='Casual Dating Communication Service';;
			unblind.date)
				department='Premier Dating Communication Service';;
			bemylil.baby)
				department='Sugar Baby Dating Communication Service';;
			dollhouse.cam)
				department='Live Adult Entertainment';;
			wifeknows.best)
				province='Florida'
				locality='Venice'
				organization='Feminine Society'
				department='Encouraging Ladies and Family Values';;
			dadsmore.fun|daddy.bar|dads.wtf)
				province='Ohio'
				locality='Toledo'
				organization='Lost & Found Fathers Coalition'
				department='Supporting Fatherhood and Family Values';;
			dad.university|man.coach)
				organization='Fatherhood Society'
				department='Coaching Men and Fathers';;
			faith.agency)
				organization='Family Uplifting Inclusive Religious Society'
				department='Promoting Faith, Spirituality and Family Unity';;
			*)
				echo "ERROR: skipping ssl key generation and certificate registration for client zone $z" >&2
				continue
		esac
		if [ ! -f /etc/ssl/private/$z.key ] || [ ! -f /etc/ssl/csrs/$z.csr ]; then
			nu_ssl -h $z -b 4096 -n $country -p "$province" -l "$locality" -o "$organization" -u "$department" -S
		fi
		if [ ! -f /etc/ssl/csrs.next/$z.csr ]; then
			nu_ssl -N -h $z -b 4096 -n $country -p "$province" -l "$locality" -o "$organization" -u "$department" -S
		fi
	)
	nu_acme_renew -j ns $z
	nu_ssl -j ns -F -h $z -tt
done

ADMIN_USER=`pw usershow -u 1001 | cut -d : -f 1`
nu_jail -j www -i 127.1.0.7 -P -I http -I https -x ${ADMIN_USER:+-u $ADMIN_USER} -q
nu_http -C /var/jail/www -s -IIII
for z in $infra_domain $client_zones; do
	(cd /etc/ssl && tar -cf - certs/$z.ca.crt certs/$z.crt csrs.next/$z.csr csrs/$z.csr private/$z.key | tar -xvf - -C /var/jail/www/etc/ssl/)
	case $z in
		goonies.pro|\
		nuos.xyz|\
		cropcircle.systems|nu.zone|nu.click)
			strict=;;
		woneye.site|uglybagsofmostlywater.club|\
		entire.ninja|\
		macleod.host|goon.store|gangsta.tech|thug.digital|bully.ninja|emptier.space|bravest.world|\
		cargobay.net|ccsys.com|nuos.org|nuos.net|\
		nu.cash|nu.chat|nu.email|nu.gold|nu.live|nu.lol|nu.money|nu.parts|nu.place|nu.school|nu.show|nu.software|nu.team|\
		uhax.tv|pawn.today|freer.trade|xng.trade|xchng.trade|unblind.date|blindish.date|bemylil.baby|dollhouse.cam|\
		wifeknows.best|dadsmore.fun|daddy.bar|dads.wtf|dad.university|man.coach|faith.agency)
			strict=y;;
		*)
			echo "ERROR: skipping http service configuration for client zone $z" >&2
			continue
	esac
	nu_http_host -C /var/jail/www -a -s${strict:+sss} -kkf -G -i -u ${ADMIN_USER:-root} -h $z
done

for z in ccsys.com; do
	sed -i '' -e "/\\<Content-Security-Policy\\>/s:object-src 'none':plugin-types application/pdf:" /var/jail/www/usr/local/etc/apache*/Includes/$z.conf
	${ADMIN_USER:+env -i} chroot ${ADMIN_USER:+-u 1001 -g 1001} /var/jail/www /bin/sh <<EOF
d=\`mktemp -d\`
cd \$d
`which pdftex` /usr/nuos/share/examples/tex/cv.tex
mv cv.pdf /home/$ADMIN_USER/$z/www/public/resume.pdf
rm -rv \$d
EOF
	${ADMIN_USER:+env -i} chroot ${ADMIN_USER:+-u 1001 -g 1001} /var/jail/www /bin/sh -c "cat > /home/$ADMIN_USER/$z/www/public/index.css" <<'EOF'
html {
	background: LightSteelBlue;
	color: DimGray;
	font-size: 0;
}
body {
	font-family: Helvetica, Verdana, Arial, sans-serif;
	font-size: 12pt;
	line-height: 1.125;
	margin: 1em;
}
a {
	color: SteelBlue;
}
h1, h2, h3, h4, h5, h6 {
	font-weight: bold;
}
h1 {
	font-size: 2em;
	margin: 0.67em 0;
}
h2 {
	font-size: 1.5em;
	margin: 0.83em 0;
}
h3 {
	font-size: 1.17em;
	margin: 1em 0;
}
h4 {
	font-size: 1em;
	margin: 1.33em 0;
}
h5 {
	font-size: 0.83em;
	margin: 1.67em 0;
}
h6 {
	font-size: 0.67em;
	margin: 2.33em 0;
}
p {
	margin: 1em 0;
}
address {
	font-style: italic;
}
EOF
	${ADMIN_USER:+env -i} chroot ${ADMIN_USER:+-u 1001 -g 1001} /var/jail/www /bin/sh -c "cat > /home/$ADMIN_USER/$z/www/public/index.html" <<'EOF'
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="index.css" rel="stylesheet" type="text/css" />
<title>ccsys.com</title>
</head>
<body>
<h1>ccsys.com</h1>
<h2>Crop Circle Systems</h2>
<h3><a href="resume.pdf">Chad Jacob Milios, CEO</a></h3>
<p><address>
	1256 Glendora Rd.<br/>
	Kissimmee, FL 34759
</address></p>
<p>
	<a href="tel:+16143973917">(614) 397-3917</a><br/>
</p>
</body>
EOF
done

case $infra_domain in
	cargobay.net) link=https://ccsys.com/;;
	woneye.site) link=https://uglybagsofmostlywater.club/;;
	macleod.host) link=home/;;
esac
i=1; for z in $org_zones; do
	mkdir -p /var/jail/www/usr/local/etc/apache24/Includes/VirtualHost.custom
	${ADMIN_USER:+env -i} chroot ${ADMIN_USER:+-u 1001 -g 1001} /var/jail/www `which nu_http_host_snowtube` -h $z -l $link -S "`echo $org_zones | xargs -n 1 | sed -E -e 's|^(.*)$|https://\1/|'`" -s $i -g >> /var/jail/www/usr/local/etc/apache24/Includes/VirtualHost.custom/$z.conf
i=$(($i+1)); done

service jail start www


# for z in $zones; do
#   if first $z of $zones; then
#     nu_vm -i
#     #nu_pgsql -n -s -h $z
#     #nu_ftp -s -h $z
#   fi
# done
