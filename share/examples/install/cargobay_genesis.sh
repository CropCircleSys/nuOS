zones='cargobay.net ccsys.com cropcircle.systems nuos.org nuos.net nu.cash nu.chat nu.click nu.email nu.gold nu.live nu.lol nu.money nu.parts nu.place nu.school nu.show nu.software nu.team nu.zone uhax.tv pawn.today freer.trade xng.trade xchng.trade unblind.date blindish.date bemylil.baby dollhouse.cam dads.wtf faith.agency'

for z in $zones; do
  
  # This must be two characters. (standard: ISO 3166-1 alpha-2; e.g. blank is XX)
  country=US
  
  # These must be defined, but they can be the empty string.
  province='Florida'
  locality='Kissimmee'
  organization='Crop Circle Systems'
  
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
      department='Next Underground Operating System';;
    nuos.net)
      department='National Union Online Service';;
    nu.zone)
      department='Authority Registration';;
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
      department='Advertising and Trend Analysis';;
    nu.parts)
      department='Construction and Manufacturing';;
    nu.school)
      department='Knowledge Library and Training Academy';;
    nu.money)
      department='Cryptographic Instrument Issuance and Offering Service';;
    nu.gold)
      department='Cryptographic Assets and Democratic Service';;
    nu.cash)
      department='Cryptographic Monetary Products';;
    uhax.tv)
      department='Hacker News and Entertainment';;
    pawn.today)
      department='Collateralized Lending Market Portal';;
    freer.trade)
      department='Community Goods and Services Market Portal';;
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
    dads.wtf)
      province='Ohio'
      locality='Toledo'
      organization='Fatherhood Society'
      department='Supporting Fatherhood and Family Values';;
    faith.agency)
      department='Supporting Faith and Spirituality';;
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
    cargobay.net|ccsys.com|nuos.org|nuos.net|nu.cash|nu.chat|nu.email|nu.gold|nu.live|nu.lol|nu.money|nu.parts|nu.place|nu.school|nu.show|nu.software|nu.team|uhax.tv|pawn.today|freer.trade|xng.trade|xchng.trade|unblind.date|blindish.date|bemylil.baby|dollhouse.cam|dads.wtf|faith.agency)
      strict=y;;
    *) die
  esac

  nu_http_host -a -s${strict:+sss} -kkf -G -u $ADMIN_USER -h $z
  
done
