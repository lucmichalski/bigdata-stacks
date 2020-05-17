#!/bin/bash

#telnet 127.0.0.1 80
#sudo netstat -plnt


##
# Print a list of used ports on host
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
##
function warp_net_get_used_ports() {

    raw=$(netstat -plnt |  tr -s ' ' | cut -d ' ' -f 4)

    #echo "$raw" #For debug

    while read -r line; do
        #echo "... $line ..."

        if [[ $line =~ ([0-9]+)$ ]]; then
            strresult=${BASH_REMATCH[1]}
            echo "- $strresult"
        else
            echo "unable to parse string $line"
        fi

    done <<< "$raw"
}

##
# Check if a given number port is used by an application 
# Use:
#    if ! warp_net_port_in_use 80 ; then
#        echo "Free port"
#    else
#        echo "Bussy port"
#    fi;
#
# Globals:
#   None
# Arguments:
#   $1 Port number. Ex. 8080
# Returns:
#   0 when port is in use
#   1 when port is free
##
function warp_net_port_in_use() {
    port=$1

    # raw=$(netstat -plnt 2>/dev/null |  tr -s ' ' | cut -d ' ' -f 4 | grep ":$port$" | tail -n 1)
    
    # if [[ "$raw" = "" ]]; then
    #     return 1 #Port in free
    # else
    #     return 0 #Port is bussy
    # fi

    nc -z 127.0.0.1 $port 2>/dev/null
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi

}

##
# Check if a given number ip is used by an container 
# Use:
#    if ! warp_net_ip_in_use 172.10.0.10 ; then
#        echo "Free IP"
#    else
#        echo "Bussy IP"
#    fi;
#
# Globals:
#   None
# Arguments:
#   $1 IP number. Ex. 172.10.0.10
# Returns:
#   0 when IP is in use
#   1 when IP is free
##
function warp_net_ip_in_use() {
    CHECK_IP_ADDRESS=$1
	PS=$(docker ps -aq)

#	if [ ! -z $PS ]
#	then
#		raw=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' `docker ps -qa` | grep -w $CHECK_IP_ADDRESS)
#	fi

#	if [ ! -z $raw ]
#	then
#		return 0
#	else 
		return 1
#	fi
}

##
# Check if a given rango ip is used by an container 
# Use:
#    if warp_check_range_ip 172.10.0.10 ; then
#        echo "wrong range"
#    else
#        echo "range Ok"
#    fi;
#
# Globals:
#   None
# Arguments:
#   $1 IP number. Ex. 172.10.0.10
# Returns:
#   0 when range is wrong
#   1 when range is Ok
##
function warp_check_range_ip() {

    CHECK_RANGE_IP=$1

	D=$(echo $CHECK_RANGE_IP | cut -f4 -d . )

	if [ $D -lt $MIN_RANGE_IP ] ; then 
		return 0
	else
		return 1
	fi
}

##
# change settings from mono to multi project
#
warp_network_multi() {

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_ports/i
	   .
	   /BEGIN webserver_ports/+1,/END webserver_ports/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_ports_multi.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_network_ip/i
	   .
	   /BEGIN webserver_network_ip/+1,/END webserver_network_ip/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_network_multi.yml
	   wq
	EOF
 
	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN networks/i
	   .
	   /BEGIN networks/+1,/END networks/-1d
	   .-1r ./.warp/setup/networks/tpl/network_multi.yml
	   wq
	EOF

}

##
# change settings from multi to mono project
#
warp_network_mono() {

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_ports/i
	   .
	   /BEGIN webserver_ports/+1,/END webserver_ports/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_ports_mono.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_network_ip/i
	   .
	   /BEGIN webserver_network_ip/+1,/END webserver_network_ip/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_network_mono.yml
	   wq
	EOF
 
	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN networks/i
	   .
	   /BEGIN networks/+1,/END networks/-1d
	   .-1r ./.warp/setup/networks/tpl/network_mono.yml
	   wq
	EOF

}

warp_network_varnish_mono_yes() {
	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_ports/i
	   .
	   /BEGIN webserver_ports/+1,/END webserver_ports/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_ports_multi.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN proxy_ports/i
	   .
	   /BEGIN proxy_ports/+1,/END proxy_ports/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_ports_mono.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_network_ip/i
	   .
	   /BEGIN webserver_network_ip/+1,/END webserver_network_ip/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_network_mono.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN proxy_network_ip/i
	   .
	   /BEGIN proxy_network_ip/+1,/END proxy_network_ip/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_network_mono.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN networks/i
	   .
	   /BEGIN networks/+1,/END networks/-1d
	   .-1r ./.warp/setup/networks/tpl/network_mono.yml
	   wq
	EOF
}

warp_network_varnish_mono_no() {
	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_ports/i
	   .
	   /BEGIN webserver_ports/+1,/END webserver_ports/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_ports_mono.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN proxy_ports/i
	   .
	   /BEGIN proxy_ports/+1,/END proxy_ports/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_ports_multi.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_network_ip/i
	   .
	   /BEGIN webserver_network_ip/+1,/END webserver_network_ip/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_network_mono.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN proxy_network_ip/i
	   .
	   /BEGIN proxy_network_ip/+1,/END proxy_network_ip/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_network_mono.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN networks/i
	   .
	   /BEGIN networks/+1,/END networks/-1d
	   .-1r ./.warp/setup/networks/tpl/network_mono.yml
	   wq
	EOF
}

warp_network_varnish_multi_yes() {
	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_ports/i
	   .
	   /BEGIN webserver_ports/+1,/END webserver_ports/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_ports_multi.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN proxy_ports/i
	   .
	   /BEGIN proxy_ports/+1,/END proxy_ports/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_ports_multi.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_network_ip/i
	   .
	   /BEGIN webserver_network_ip/+1,/END webserver_network_ip/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_network_mono.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN proxy_network_ip/i
	   .
	   /BEGIN proxy_network_ip/+1,/END proxy_network_ip/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_network_multi.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN networks/i
	   .
	   /BEGIN networks/+1,/END networks/-1d
	   .-1r ./.warp/setup/networks/tpl/network_multi.yml
	   wq
	EOF
}

warp_network_varnish_multi_no() {
	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_ports/i
	   .
	   /BEGIN webserver_ports/+1,/END webserver_ports/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_ports_multi.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN proxy_ports/i
	   .
	   /BEGIN proxy_ports/+1,/END proxy_ports/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_ports_multi.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN webserver_network_ip/i
	   .
	   /BEGIN webserver_network_ip/+1,/END webserver_network_ip/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_network_multi.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN proxy_network_ip/i
	   .
	   /BEGIN proxy_network_ip/+1,/END proxy_network_ip/-1d
	   .-1r ./.warp/setup/webserver/tpl/webserver_network_mono.yml
	   wq
	EOF

	cat <<-'EOF' | sed -e 's/^ *//' -e 's/ *$//' | ed -s $DOCKERCOMPOSEFILE
	   H
	   /BEGIN networks/i
	   .
	   /BEGIN networks/+1,/END networks/-1d
	   .-1r ./.warp/setup/networks/tpl/network_multi.yml
	   wq
	EOF
}

#warp_network_create() {

#	CHECK "Subnet": "172.33.50.0/24" $NETWORK_NAME

#	networkOutput=$(docker network inspect --format "{{.Name}}" $NETWORK_NAME)
#	if [ "$networkOutput" != "$NETWORK_SUBNET" ]; then
#		docker network rm $NETWORK_NAME
#		docker network create --subnet=$NETWORK_SUBNET $NETWORK_NAME
#	fi

#	docker network create --subnet=$NETWORK_SUBNET $NETWORK_NAME

#	docker network rm $NETWORK_NAME ;

#	docker network create \
#	--driver=bridge \
#	--subnet=$NETWORK_SUBNET \
#	--ip-range=$NETWORK_SUBNET \
#	--gateway=$NETWORK_GATEWAY \
#}