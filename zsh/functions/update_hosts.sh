#!/bin/bash
TMP_FILE="/tmp/hosts"
HOSTS_FILE="/etc/hosts"

touch ${TMP_FILE}

for URL in  http://adaway.org/hosts.txt \
                        http://winhelp2002.mvps.org/hosts.txt \
                        http://hosts-file.net/ad_servers.asp \
                        http://someonewhocares.org/hosts/hosts
do curl -s ${URL} | grep "^127.0.0.1" >> ${TMP_FILE}
done

# remember to add here your custom known hosts:
echo "::1 localhost
127.0.0.1 localhost
127.0.0.1 localhost.localdomain
fe80::1%lo0 localhost
255.255.255.255 broadcasthost
" > ${HOSTS_FILE}

# use 0.0.0.0 instead of 127.0.0.1 (faster but not 100% compatible)
awk '!/ localhost/'{'print "0.0.0.0 "$2'} ${TMP_FILE} | sort | uniq >> ${HOSTS_FILE}

sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder
