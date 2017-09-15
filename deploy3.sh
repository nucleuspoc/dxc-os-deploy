#!/bin/bash

. creds.sh

set -e
set -x


servers=( kube001 )

for server in "${servers[@]}"; do 
# govc vm.clone -vm packer-centos-7.3-x86_64 -customization=$server -ds ukrd_esx_mgmt_data_002 -net DMZ_Internet_Vlan201 $server &
	govc vm.clone -vm packer-centos-7.3-x86_64 -waitip=true -customization='linux 2cpu 8gb' -ds USPNRMMRR002 -net SCLDM0630 $server &

done

wait $(jobs -p)

for server in "${servers[@]}"; do 
	sudo sed -i "/$server/d" /etc/hosts
done

sleep 5


for server in "${servers[@]}"; do 
	IPADDRESS=`govc vm.info $server | grep 'IP address' | cut -d':' -f2`
	# sed -i "s/.*$server.*/$server $IPADDRESS/" /etc/hosts
	echo $IPADDRESS  $server | sudo tee --append /etc/hosts
done




for server in "${servers[@]}"; do 
	sshpass -f password.txt ssh-copy-id -i ~/.ssh/kube_rsa.pub vagrant@$server &
done



wait $(jobs -p)
