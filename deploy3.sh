#!/bin/bash

. creds.sh

set -e
set -x


servers=( kube001 kube002 kube003 )

for server in "${servers[@]}"; do 
# govc vm.clone -vm packer-centos-7.3-x86_64 -customization=$server -ds ukrd_esx_mgmt_data_002 -net DMZ_Internet_Vlan201 $server &
	govc vm.clone -vm packer-centos-7.3-x86_64 -waitip=true -customization='linux 2cpu 8gb' -ds USPNRMMRR002 -c 2 -m 8092 -net SCLDM0630 $server &

done

wait $(jobs -p)

for server in "${servers[@]}"; do 
	sudo sed -i "/$server/d" /etc/hosts
done

sleep 5

IPADDRESSES=""


for server in "${servers[@]}"; do 
	IPADDRESS=`govc vm.info $server | grep 'IP address' | cut -d':' -f2`
	IPADDRESSES=$IPADDRESSES,$IPADDRESS
	# sed -i "s/.*$server.*/$server $IPADDRESS/" /etc/hosts
	echo $IPADDRESS  $server | sudo tee --append /etc/hosts
done


for server in "${servers[@]}"; do 
	sshpass -f password.txt ssh-copy-id -i ~/.ssh/kube_rsa.pub vagrant@$server &
done

wait $(jobs -p)


for server in "${servers[@]}"; do 
	ansible all -i=",$server" --become -m lineinfile -a "path=/etc/yum.conf regexp='^proxy=' line='proxy=http://16.85.88.10:8080'" || true
	ansible all -i=",$server" --become -m shell -a "systemctl stop firewalld" || true
	ansible all -i=",$server" --become -m shell -a "systemctl disable firewalld" || true

done

wait $(jobs -p)

# for server in "${servers[@]}"; do 
# 	ansible all -i=",$server" --become -m shell -a "firewall-cmd --reload"  || true &
# done

# wait $(jobs -p)


# kubespraypreparecommand=kubespray prepare --nodes 

# for server in "${servers[@]}"; do 
# 	kubespraypreparecommand=$kubespraypreparecommand $server[ansible_ssh_host=$server]
# done

# $kubespraypreparecommand

echo $IPADDRESSES


