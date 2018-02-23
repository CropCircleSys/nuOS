zones='cargobay.net nuos.org nu.zone nu.software nu.email nu.place nu.chat nu.team nu.show nu.live nu.lol nu.click nu.money nu.gold nu.cash cropcircle.systems ccsys.com uhax.tv pawnbase.com unblind.date blindish.date dominatrixbunny.com dominatrixbunnies.com dominatrixbunnys.com daddyoh.life daddyoh.org'

for z in $zones; do
  
  # This must be two characters. (standard: ISO 3166-1 alpha-2; e.g. blank is XX)
  country=US
  
  # These must be defined, but they can be the empty string.
  province='Florida'
  locality='Kissimmee'
  organization='Crop Circle Systems, Inc.'
  
  nu_ns_host -h $z
  
  if first $z of $zones; then
    department='System and Network Security'
    nu_ssl -h ca.$z -b 4096 -s -W -d 512 -n $country -p "$province" -l "$locality" -o "$organization" -u "$department" -S
  fi
  
  sleep 7 # don't slurp up entropy out of the system so fast if you value these keys
  
  case $z in
    cargobay.net)
      department='Network Infrastructure';;
    cropcircle.systems)
      department='Customer Service';;
    ccsys.com)
      department='Sales and Customer Support';;
    nuos.org)
      department='Community Outreach and Service';;
    nu.zone)
      department='Authority Delegation and Name Assignment';;
    nu.software)
      department='Software Distribution Center';;
    nu.place)
      department='Secure Storage Service';;
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
      department='Social Media Archival and Chronology';;
    nu.click)
      department='Advertising and Trend Analysis Network';;
    nu.money)
      department='Financial News and Services';;
    nu.gold)
      department='Cryptographic Democratic Service';;
    nu.cash)
      department='Cryptographic Monetary Products';;
    uhax.tv)
      department='Hacker News and Entertainment';;
    pawnbase.com)
      department='Lending';;
    blindish.date)
      department='Casual Dating Information Service';;
    unblind.date)
      department='Premier Dating Information Service';;
    dominatrixbunny.com|dominatrixbunnies.com|dominatrixbunnys.com)
      province='Florida'
      locality='Tampa'
      organization="Jenny's Cam, LLC"
      department='Goddess Worship Products and Entertainment';;
    daddyoh.life|daddyoh.org)
      province='Ohio'
      locality='Toledo'
      organization='Daddy-Oh Society'
      department='Supporting Fatherhood and Family Values';;
    *) die
  esac
  
  nu_ssl -h $z -b 4096 -n $country -p "$province" -l "$locality" -o "$organization" -u "$department" -S
  
  if first $z of $zones; then
    nu_ca -h $z
    nu_vpn -h $z -q
    nu_vm -i
    nu_http -s -IIII
  fi
done

echo

for z in $zones; do
  nu_ns_host -h $z -k
done

echo
read -p 'Press enter once namespace authority has been established for all zones listed above.'

for z in $zones; do
  
  nu_ssl -h $z -L
  nu_ssl -h $z -tt
  
  if first $z of $zones; then
    #nu_pgsql -n -s -h $z
    #nu_ftp -s -h $z
    nu_smtp -s -e -h $z
    nu_imap -s -e -h $z
  fi
  
  nu_smtp_host -h $z
  
  case $z in
    cropcircle.systems|nu.zone|nu.click)
      strict=;;
    cargobay.net|ccsys.com|nuos.org|uhax.tv|pawnbase.com|nu.software|nu.place|nu.email|nu.chat|nu.team|nu.show|nu.live|nu.lol|nu.money|nu.gold|nu.cash|unblind.date|blindish.date|dominatrixbunny.com|dominatrixbunnies.com|dominatrixbunnys.com|daddyoh.life|daddyoh.org)
      strict=y;;
    *) die
  esac

  nu_http_host -a -s${strict:+sss} -kkf -G -u $ADMIN_USER -h $z
  
done
