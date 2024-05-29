#!/bin/sh

lookup_port() {
	local bridge=$1
	local portno=$(printf "0x%x" $2)
	local path


	for path in $(grep -l $portno /sys/class/net/"$bridge"/lower_*/brport/port_no); do
		basename $(readlink "${path%/brport/port_no}")
		return 0
	done

	return 1
}

parse_fdb() {
	local bridge=$1
	local callback=${2:-echo}
	local record

    if [ ! -d /sys/class/net/"$bridge" ]; then
        echo "Device '$bridge' does not exist!"
        exit 1
    fi

	IFS=$'\n'

	for record in $(
		hexdump -v -e '5/1 "%02x:" 1/1 "%02x " 1/1 "%u " 1/1 "%u " 1/4 "%u " 1/1 "%u " 3/1 "" "\n"' \
			"/sys/class/net/$bridge/brforward"
	); do
		IFS=' '
		set -- $record

		local mac=$1
		local port=$(lookup_port "$bridge" $(($5 << 16 | $2)))
		local islocal=$3
		local timer=$4

		${callback:-echo} "$mac" "$port" "$islocal" "$timer" 
	done
}

dump_entry() {
	local mac=$1
	local ifname=$2
	local islocal=$3
	local timer=$4

	printf "MAC: %s  Ifname: %s\tLocal? %d  Timer: %d.%d\n" \
		"$mac" "$ifname" "$islocal" \
		$((timer / 100)) $((timer % 100))
}

parse_fdb "${1:-br-lan}" dump_entry
