#!/bin/bash

# check args
if [[ $# -ne 2 ]]; then
     echo "usage: $0 <network-prefix> <port>"
     exit 1
fi

network_prefix=$1
port=$2

# validate the port
if ! [[ "$port" =~ ^[0-9]+$ ]]; then
    echo "incorrect port number!!!! '$port'. gooby."
    exit 1
fi

# check if the port is valid
if (( port < 1 || port > 65535 )); then
    echo "must be port between 1 and 65535. gooby."
    exit 1
fi

echo "start scan -- ${network_prefix}.0/24 for port $port..."

# scan through all ips from .1 to .254
for ip in {1..254}; do
    host="${network_prefix}.$ip"

    # ping the host
    if ping -c 1 -W 1 "$host" &>/dev/null; then
        # check if pjort is open
        if timeout 0.1 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
            echo "$host:$port is open"
        fi
    fi
done

echo "scan done, go nuts."
