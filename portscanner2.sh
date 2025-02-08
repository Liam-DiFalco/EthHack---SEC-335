#!/bin/bash

# Check to see if you didnt do it right XP
if [[ $# -ne 2 ]]; then
     echo "Usage: $0 <hostfile> <portfile>"
     exit 1
fi
#
hostfile=$1
portfile=$2
#
#         # Check if files exist and are readable
if [[ ! -f "$hostfile" || ! -r "$hostfile" ]]; then
	echo "cannot read host file '$hostfile'"
	exit 1
fi
#
if [[ ! -f "$portfile" || ! -r "$portfile" ]]; then
	echo "cannot read port file '$portfile'"
	exit 1
fi
#
echo "Here we go B)"

#Scan hosts and ports
for host in $(cat "$hostfile"); do
	if ! ping -c 1 -W 1 "$host" &>/dev/null; then
		echo "$host is unreachable, MOVIN ON!!"
		continue
	fi

	for port in $(cat "$portfile"); do
		if ! [[ "$port" =~ ^[0-9]+$ ]]; then
			echo "invalid port '$port' in '$portfile', not doing it"
			continue
		fi

		if timeout 0.5 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
			echo "$host:$port is open"
		fi
	done
done

echo "Scan complete."
