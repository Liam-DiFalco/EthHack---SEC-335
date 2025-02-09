#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <network-prefix> <dns-server>"
    exit 1
fi

network_prefix=$1
dns_server=$2

if ! [[ "$dns_server" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "invalid IP address. gooby."
    exit 1
fi

echo "DNS lookup on network ${network_prefix}.0/24 using $dns_server"

for ip in {1..254}; do
    host="${network_prefix}.$ip"

    reverse_dns=$(nslookup "$host" "$dns_server" | grep 'name =' | awk '{print $4}')

    if [[ $? -eq 0 && -n "$reverse_dns" ]]; then
        # Reverse address in the required format
        reverse_dns_formatted=$(echo "$host" | awk -F '.' '{print $4 "." $3 "." $2 "." $1 ".in-addr.arpa"}')
        echo "$reverse_dns_formatted: $reverse_dns"
    fi
done

echo "Donezo."
