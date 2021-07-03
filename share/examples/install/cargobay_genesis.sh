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
		
		infra_domain=CargoBay.net
		corp_zones='CCSys.com CropCircle.Systems'
		org_zones='nuOS.net nuOS.org nu.Cash nu.Chat nu.Click nu.Email nu.Gold nu.Live nu.LOL nu.Money nu.Parts nu.Place nu.School nu.Show nu.Software nu.Team nu.Zone'
		prod_zones='Candid.Press Leak.Report UHax.TV Pawn.Today Freer.Trade Xng.Trade HyperNatural.Art ExoCosmic.Art Freshest.Garden EcoDome.Farm FeedOur.World Pure.Doctor NoLifeGuardOnDuty.FYI Legit.Blue Crooked.Blue Oath.Report Justice.House Civix.Tech Brave.Help Hero.Rent Unblind.Date Blindish.Date BeMyLil.Baby DollHouse.Cam Goddess.One Goddess.Institute Her.Services Lady.Ninja Angel.Directory Cuddle.Expert Tickle.Ninja Dominatrix.House Dominatrix.Army Dominatrix.Fashion Fetish.Pink Brat.Chat Homies.Fund Together.Rehab WifeKnows.Best DadsMore.Fun Daddy.Bar Dads.WTF Dad.University Man.Coach Faith.Agency'
		
		sec_dept='System & Network Security'
		net_dept='Network Infrastructure & Operations'
		
		init_emails='chad@ccsys.com milios@ccsys.com chuck@nu.email chad@nu.email jake@nu.email'
	;;
	
	woneye.site|uglybagsofmostlywater.club)
		
		country=US
		
		province='Oregon'
		locality='Astoria'
		organization='Lighthouse Lounge'
		
		OWNER_ACCT=anne
		OWNER_NAME='Angelina Fratelli'
		
		infra_domain=WonEye.site
		corp_zones='MeatPopsicle.VIP UglyBagsOfMostlyWater.Club'
		org_zones='nuOS.xyz nunu.foundation'
		prod_zones='Bedlam.City Bumpkin.Town Deplorable.Town Deplorable.One Fattylicious.Club 8aG.Club'
		
		sec_dept='Development & Production Quality Assurance'
		net_dept='Architecture Quality Assurance'
		
		init_emails='willy@woneye.site korben@meatpopsicle.vip giant@uglybagsofmostlywater.club bofh@nuos.xyz raven@nunu.foundation'
	;;
	
	bofh.vip)
	
		country=SU
		
		province='Monastery'
		locality='Scary Devil'
		organization='Path-E-Tech Management'
		
		OWNER_ACCT=phb
		OWNER_NAME='Pointy Haired Boss'
		
		infra_domain=BOFH.vip
		org_zones='USAwhite.house FBI.management CIA.ventures DHS.agency NSA.direct CDC.doctor'
		prod_zones='USwhite.house'
		
		sec_dept='Red Team'
		net_dept='Blue Team'
		
		init_emails='ceo@bofh.vip phb@bofh.vip pfy@bofh.vip root@bofh.vip toor@bofh.vip daemon@bofh.vip operator@bofh.vip pop@bofh.vip nobody@bofh.vip'
	;;
	
	entire.ninja)
		
		country=QU
		
		province='Hi no Kuni'
		locality='Konohagakure'
		organization='Foundation'
		
		OWNER_ACCT=naruto
		OWNER_NAME='Naruto Uzumaki'
		
		infra_domain=Entire.Ninja
		
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
		
		infra_domain=MacLeod.host
		corp_zones='Goon.Store Goonies.Pro'
		org_zones='Gangsta.Tech Thug.Digital Bully.Ninja'
		prod_zones='Emptier.Space Bravest.World McLeod.host'
		
		sec_dept='Infrastructure & Operations Quality Assurance'
		net_dept='System Engineering Quality Assurance'
		
		init_emails='connor@macleod.host one@bravest.world zero@emptier.space mikey@goonies.pro mouth@goonies.pro data@goonies.pro chunk@goonies.pro brand@goonies.pro stef@goonies.pro andy@goonies.pro mama@goon.store jake@goon.store francis@goon.store sloth@goon.store'
	;;
	*)
		echo "ERROR: unsure of identity and ownership, check configuration" >&2
		exit 1
esac

client_zones="${corp_zones-} ${org_zones-} ${prod_zones-}"
zones="$infra_domain $client_zones"



while IFS=: read n ip; do
	setvar my_ip_$n $ip
	echo my_ip_$n=$ip
done <<EOF
`ifconfig net0 | grep -E '^[[:blank:]]*inet' | xargs -L 1 | cut -w -f 2 | grep -n .`
EOF

echo infra_domain=$infra_domain
echo client_zones=$client_zones
env


infra_domain_lc=`echo $infra_domain | tr [[:upper:]] [[:lower:]]`

enable_svc jail

if [ ! -d /var/jail/resolv ]; then
	nu_jail -j resolv -S domain -T a.ns -T b.ns -x -q -i 127.1.0.1
	nu_ns_cache -C /var/jail/resolv -s
	{ grep -w -v nameserver /var/jail/resolv/etc/resolv.conf; getent hosts resolv.jail | cut -w -f 1 | xargs -n 1 echo nameserver; } > /etc/resolv.conf
	cp -av /var/jail/resolv/etc/resolvconf.conf /etc/resolvconf.conf
fi

if [ ! -d /var/jail/ns -a ! -d /var/jail/a.ns -a ! -d /var/jail/b.ns ]; then
	nu_jail -j ns -S domain -x -q -i 127.1.0.2
	env ALIAS_IP=$my_ip_1 nu_jail -j a.ns -i 127.1.0.3 -AP -S domain -x -q
	env ALIAS_IP=$my_ip_2 nu_jail -j b.ns -i 127.1.0.4 -AP -S domain -x -q
	nu_ns_server -C /var/jail/ns -d -k 4096 -z 2048 -i $my_ip_1 -i $my_ip_2 -s a.ns.jail -s b.ns.jail
	nu_ns_server -C /var/jail/a.ns -i $my_ip_1 -i $my_ip_2 -m ns.jail
	nu_ns_server -C /var/jail/b.ns -i $my_ip_1 -i $my_ip_2 -m ns.jail
	if [ -d /root/nuos_deliverance/ns ]; then
		tar -cf - -C /root/nuos_deliverance/ns/knotdb keys | tar -xvf - -C /var/jail/ns/var/db/knot
	fi
	service jail start resolv ns a.ns b.ns
fi

for Z in $zones; do
	z=`echo $Z | tr [[:upper:]] [[:lower:]]`
	[ ! -f /var/jail/ns/var/db/knot/$z.zone ] || continue
	for j in ns a.ns b.ns; do
		nu_ns_host -j $j -h $z
	done
	nu_sshfp -j ns -F -h $z
done

echo
for Z in $zones; do
	z=`echo $Z | tr [[:upper:]] [[:lower:]]`
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
		tar -cf - -C /root/nuos_deliverance/$s/ssl . | tar --keep-newer-files -xvf - -C /etc/ssl
	fi
done

if [ ! -f /etc/ssl/private/ca.$infra_domain_lc.key ] || [ ! -f /etc/ssl/certs/ca.$infra_domain_lc.internal.crt ]; then
	nu_ssl -h ca.$infra_domain_lc -b 4096 -s -W -d 512 -n $country -p "$province" -l "$locality" -o "$organization" -u "$sec_dept" -S
fi
if [ ! -f /etc/ssl/private/$infra_domain_lc.key ] || [ ! -f /etc/ssl/csrs/$infra_domain_lc.csr ]; then
	nu_ssl -h $infra_domain_lc -b 4096 -n $country -p "$province" -l "$locality" -o "$organization" -u "$net_dept" -S
fi
if [ ! -f /etc/ssl/certs/$infra_domain_lc.internal.crt ]; then
	nu_ca -h $infra_domain_lc
fi
if [ ! -d /usr/local/etc/openvpn ]; then
	nu_vpn -q -h $infra_domain_lc
	service openvpn start
fi

if [ ! -f /etc/ssl/csrs.next/$infra_domain_lc.csr ]; then
	nu_ssl -h $infra_domain_lc -b 4096 -n $country -p "$province" -l "$locality" -o "$organization" -u "$net_dept" -S -N
fi
nu_acme_renew -j ns $infra_domain_lc
host -rt tlsa _443._tcp.$infra_domain_lc ns.jail | grep -w 'has TLSA record' || nu_ssl -j ns -F -h $infra_domain_lc -tt

if [ ! -d /var/jail/postmaster ]; then
	nu_jail -j postmaster -i 127.1.0.5 -P -S smtp -I submission -x -q
	(cd /etc/ssl && tar -cf - certs/$infra_domain_lc.ca.crt certs/$infra_domain_lc.crt csrs.next/$infra_domain_lc.csr csrs/$infra_domain_lc.csr private/$infra_domain_lc.key | tar -xvf - -C /var/jail/postmaster/etc/ssl/)
	mkdir -p /var/jail/postmaster/var/imap/socket
	service jail start postmaster
	nu_smtp -j postmaster -s -e -h $infra_domain_lc
	nu_user -C /var/jail/postmaster -h $infra_domain_lc -a -d net -u $OWNER_ACCT -n "$OWNER_NAME" < /root/owner_pass
fi

if [ ! -d /var/jail/postoffice ]; then
	nu_jail -j postoffice -i 127.1.0.6 -m -P -I imap -I imaps -I pop3 -I pop3s -I sieve -x -q
	(cd /etc/ssl && tar -cf - certs/$infra_domain_lc.ca.crt certs/$infra_domain_lc.crt csrs.next/$infra_domain_lc.csr csrs/$infra_domain_lc.csr private/$infra_domain_lc.key | tar -xvf - -C /var/jail/postoffice/etc/ssl/)
	service jail start postoffice
	nu_imap -j postoffice -s -e -h $infra_domain_lc
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
	nu_user -C /var/jail/postoffice -h $infra_domain_lc -a -u $OWNER_ACCT -n "$OWNER_NAME" < /root/owner_pass
	service jail restart postmaster postoffice
fi

for Z in $zones; do
	z=`echo $Z | tr [[:upper:]] [[:lower:]]`
	grep -w ^$z /var/jail/postmaster/usr/local/etc/postfix/domains || nu_smtp_host -C /var/jail/postmaster -h $z
	for b in operator security hostmaster postmaster webmaster whois-data; do
		grep -w ^$b@$z /var/jail/postmaster/usr/local/etc/postfix/virtual || nu_user_mail -C /var/jail/postmaster -h $infra_domain_lc -u $OWNER_ACCT -m $b@$z
	done
done
for m in $init_emails; do
	grep -w ^${m#'*'} /var/jail/postmaster/usr/local/etc/postfix/virtual || nu_user_mail -C /var/jail/postmaster -h $infra_domain_lc -u $OWNER_ACCT -m $m
done

for Z in $client_zones; do
	z=`echo $Z | tr [[:upper:]] [[:lower:]]`
	(
		case $z in
			cropcircle.systems)
				department='Customer Service';;
			ccsys.com)
				department='Sales and Customer Support';;
			nuos.org)
				department='Next Underground Operating System';;
			nuos.net)
				department='National Union Organizing Society';;
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
				department='Cryptographic Equity Issuance & Offering System';;
			nu.gold)
				department='Cryptographic Assets of Merit and Democratic Information System';;
			nu.cash)
				department='Cryptographic Debt Instruments and Monetary Products';;
			bedlam.city)
				department='Urban Culture Chronology';;
			bumpkin.town)
				department='Rural & Suburban Culture Bulletin';;
			meatpopsicle.vip)
				department='Urban Taxi Service and Gourmet Croquettes';;
			uglybagsofmostlywater.club)
				department='Cordial Community Contributor Coterie';;
			nuos.xyz)
				department='Advanced Software Research & Development';;
			nunu.foundation)
				department='Fellowship Outreach & Coordination';;
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
			usawhite.house|uswhite.house|fbi.management|cia.ventures|dhs.agency|nsa.direct|cdc.doctor)
				department='Public Service Pilot';;
			candid.press)
				department='Uncensored Journalism & Editorial Platform';;
			leak.report)
				department='Uncensored Exposé Platform';;
			uhax.tv)
				department='Hacker News and Entertainment';;
			pawn.today)
				department='Collateralized Lending Market Portal';;
			freer.trade)
				department='Community Goods & Services Market Portal';;
			xng.trade|xchng.trade)
				department='Cryptographic Instrument Market Portal';;
			hypernatural.art|exocosmic.art)
				department='Appreciation & Promotion of Art & Culture';;
			freshest.garden)
				department='Sustainable Agriculture Equipment';;
			ecodome.farm)
				department='Sustainable Agriculture Construction';;
			feedour.world)
				department='Sustainable Agriculture Global Sociopolitical Initiative';;
			pure.doctor)
				department='Traditional, Natural & Holistic Medical Information Portal';;
			nolifeguardonduty.fyi)
				department='Community Mental Health Assistance Portal';;
			legit.blue|crooked.blue)
				department='Executive Power Review & Feedback Platform';;
			oath.report)
				department='Legislative & Judicial Authority Evaluation Platform';;
			justice.house)
				department='Judicial Analysis & Review Platform';;
			civix.tech)
				department='Electronic Direct Democracy for Federated Republics';;
			brave.help)
				department='Local Assistance Communication Platform';;
			hero.rent)
				department='Local Assistance Market Portal';;
			deplorable.town)
				department='Working Class Patriot Society';;
			deplorable.one)
				department='Working Class Patriot Individuality Association';;
			blindish.date)
				department='Casual Dating Communication Service';;
			unblind.date)
				department='Premier Dating Communication Service';;
			bemylil.baby)
				department='Sugar Baby Dating Communication Service';;
			dollhouse.cam)
				department='Live Adult Entertainment';;
			goddess.one)
				department='Goddess Worship Products & Entertainment';;
			goddess.institute)
				department='Goddess Worship & Devotion Portal';;
			her.services)
				department='Private Feminine Support & Comfort';;
			lady.ninja)
				department='Women’s Empowerment Initiative';;
			angel.directory)
				department='Inspiration & Encouragement Therapy';;
			cuddle.expert)
				department='Platonic Intimate Touch Therapy';;
			tickle.ninja)
				department='Tactile Sensation & Laughter Therapy';;
			dominatrix.house|dominatrix.army)
				department='Female Authority & Discipline Therapy';;
			dominatrix.fashion)
				department='Dungeon Style Clothing & Accessories';;
			fetish.pink)
				department='Peculiar & Taboo Fanatic Communication Service';;
			brat.chat)
				department='Audacious & Brazen Communication Service';;
			homies.fund)
				department='Compassion & Philanthropy for Homeless';;
			together.rehab)
				department='Addiction Recovery Assistance';;
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
			fattylicious.club|8ag.club)
				province='Florida'
				locality='Englewood'
				organization='Alexander Marriott Memorial Society'
				department='Fattylicious Memorial Tribute';;
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
	host -rt tlsa _443._tcp.$z ns.jail | grep -w 'has TLSA record' || nu_ssl -j ns -F -h $z -tt
done

ADMIN_USER=`pw usershow -u 1001 | cut -d : -f 1`
if [ ! -d /var/jail/www ]; then
	nu_jail -j www -i 127.1.0.7 -m -P -I http -I https -x ${ADMIN_USER:+-u $ADMIN_USER} -q
	nu_http -C /var/jail/www -s -IIII
fi
for Z in $zones; do
	z=`echo $Z | tr [[:upper:]] [[:lower:]]`
	[ -f /var/jail/www/etc/ssl/certs/$z.crt -a ! /etc/ssl/certs/$z.crt -nt /var/jail/www/etc/ssl/certs/$z.crt ] || (cd /etc/ssl && tar -cf - certs/$z.ca.crt certs/$z.crt csrs.next/$z.csr csrs/$z.csr private/$z.key | tar -xvf - -C /var/jail/www/etc/ssl/)
	case $z in
		goonies.pro|\
		nuos.xyz|nunu.foundation|\
		entire.ninja|bofh.vip|\
		cropcircle.systems|nu.zone|nu.click)
			http_host_extra_flags=-s;;
		woneye.site|bedlam.city|bumpkin.town|meatpopsicle.vip|uglybagsofmostlywater.club|\
		macleod.host|goon.store|gangsta.tech|thug.digital|bully.ninja|emptier.space|bravest.world|\
		cargobay.net|ccsys.com|nuos.org|nuos.net|\
		nu.cash|nu.chat|nu.email|nu.gold|nu.live|nu.lol|nu.money|nu.parts|nu.place|nu.school|nu.show|nu.software|nu.team|\
		uhax.tv|pawn.today|freer.trade|xng.trade|hypernatural.art|exocosmic.art|freshest.garden|ecodome.farm|feedour.world|unblind.date|blindish.date|bemylil.baby|dollhouse.cam|goddess.one|goddess.institute|her.services|lady.ninja|angel.directory|cuddle.expert|tickle.ninja|dominatrix.house|dominatrix.army|dominatrix.fashion|fetish.pink|brat.chat|homies.fund|together.rehab|\
		candid.press|leak.report|pure.doctor|nolifeguardonduty.fyi|legit.blue|crooked.blue|oath.report|justice.house|civix.tech|brave.help|hero.rent|\
		deplorable.town|deplorable.one|\
		usawhite.house|uswhite.house|cdc.doctor|fbi.management|cia.ventures|dhs.agency|nsa.direct|\
		wifeknows.best|dadsmore.fun|daddy.bar|dads.wtf|dad.university|man.coach|faith.agency)
			http_host_extra_flags=-ssss;;
		mcleod.host)
			http_host_extra_flags='-ssss -r https://macleod.host/';;
		8ag.club)
			http_host_extra_flags='-ssss -r https://fattylicious.club/';;
		fattylicious.club)
			http_host_extra_flags=-ssssge;;
		*)
			echo "ERROR: skipping http service configuration for client zone $z" >&2
			continue
	esac
	[ -f /var/jail/www/usr/local/etc/apache*/Includes/$z.conf ] || nu_http_host -C /var/jail/www -a -kkf -G -P -i $http_host_extra_flags -u ${ADMIN_USER:-root} -h $z
done

if [ cargobay.net = $infra_domain_lc ]; then for Z in CCSys.com; do
	z=`echo $Z | tr [[:upper:]] [[:lower:]]`
	[ ! -f /var/jail/www/home/$ADMIN_USER/$z/www/public/index.html ] || continue
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
<title>CCSys.com</title>
</head>
<body>
<h1>CCSys.com</h1>
<h2>Crop Circle Systems</h2>
<h3><a href="resume.pdf">Chad Jacob Milios, CEO</a></h3>
<p><address>
	1256 Glendora Rd.<br/>
	Kissimmee, Florida 34759
</address></p>
<p>
	<a href="tel:+16143973917">(614) 397-3917</a><br/>
</p>
</body>
EOF
done; fi

case $infra_domain_lc in
	cargobay.net) link=lobby/;;
	woneye.site) link=https://UglyBagsOfMostlyWater.club/;;
	macleod.host) link=home/;;
	*) link=https://$infra_domain/
esac
i=1; for Z in $org_zones; do
	z=`echo $Z | tr [[:upper:]] [[:lower:]]`
	[ ! -f /var/jail/www/usr/local/etc/apache*/Includes/VirtualHost.custom/$z.conf ] || continue
	${ADMIN_USER:+env -i} chroot ${ADMIN_USER:+-u 1001 -g 1001} /var/jail/www `which nu_http_host_snowtube` -h $Z -l $link -S "`echo $org_zones | xargs -n 1 | sed -E -e 's|^(.*)$|https://\1/|'`" -s $i -g >> `echo /var/jail/www/usr/local/etc/apache*/Includes/VirtualHost.custom`/$z.conf
i=$(($i+1)); done

admin_home=${ADMIN_USER:+home/$ADMIN_USER}
: ${admin_home:=root}
for Z in $prod_zones; do
	z=`echo $Z | tr [[:upper:]] [[:lower:]]`
	[ -z "`find /var/jail/www/$admin_home/$z/www/public -type f | head -n 1`" ] || continue
	if [ -d /root/nuos_deliverance/www/$z ]; then
		tar -cf - -C /root/nuos_deliverance/www/$z . | tar -xvf - -C /var/jail/www/$admin_home/$z/www
	fi
	if [ -f /root/nuos_deliverance/www/$z.conf ]; then
		cp -v /root/nuos_deliverance/www/$z.conf /var/jail/www/usr/local/etc/apache*/Includes/VirtualHost.custom/
	fi
done

for Z in $zones; do
	z=`echo $Z | tr [[:upper:]] [[:lower:]]`
	if [ -f /root/nuos_deliverance/www/$z.fstab ]; then
		awk "\$2 !~ \"^/var/jail/www/home/[^/]*/$z/www(\$|/)\"" /etc/fstab.www > /etc/fstab.www.$$
		cat /root/nuos_deliverance/www/$z.fstab >> /etc/fstab.www.$$
		mv /etc/fstab.www.$$ /etc/fstab.www
	fi
done

mount -F /etc/fstab.www -a
service jail restart www


# for z in $zones; do
#   if first $z of $zones; then
#     nu_vm -i
#     #nu_pgsql -n -s -h $z
#     #nu_ftp -s -h $z
#   fi
# done
