!/bin/sh
_addr=`nslookup _url | grep _url -A 1 | grep Address | grep -Eo "([0-9]*\.){3}[0-9]*"`

if [[ -z `iptables --list-rule _home 2>/dev/null` ]]
  then
    iptables -N _home
fi

server1_old=`iptables --list-rule _home | grep '\-A' | grep 192.168.122.199`
server2_old=`iptables --list-rule _home | grep '\-A' | grep 192.168.122.198`

if [[ -z `echo $server1_old | grep $_addr` ]]
  then
    `iptables $server1_old | sed 's/\-A/\-D/g'`
    echo `iptables $server1_old | sed 's/\-A/\-D/g'`
    iptables -A _home -s $_addr -d 192.168.122.199 -j ACCEPT
fi

if [[ -z `echo $server2_old | grep $_addr` ]]
  then
    `iptables $server2_old | sed 's/\-A/\-D/g'`
    echo `iptables $server2_old | sed 's/\-A/\-D/g'`
    iptables -A _home -s $_addr -d 192.168.122.198 -j ACCEPT
fi

if [[ -z `iptables --list-rule | grep FORWARD | grep _home` ]]
  then
    iptables -A FORWARD -j _home
fi

iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited
iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited
