#!/bin/bash

. creds.sh

set -e
set -x


servers=( k01001 k01002 k01003 k01004 k01005 )

# for server in "${servers[@]}"; do 
# # govc vm.clone -vm packer-centos-7.3-x86_64 -customization=$server -ds ukrd_esx_mgmt_data_002 -net DMZ_Internet_Vlan201 $server &
# 	MSYS_NO_PATHCONV=1 govc vm.clone -vm DXC-RHEL7.3-TEMPLATE -folder=platform -ds ukrd_esx_mgmt_data_002 -net DMZ_Internet_Vlan201 $server &

# done

# wait $(jobs -p)

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
	# sshpass -f password.txt ssh-copy-id -i ~/.ssh/kube_rsa.pub vagrant@$server &
	ssh-copy-id -i ~/.ssh/dxckubespraydev.pub vagrant@$server &
done

wait $(jobs -p)


# for server in "${servers[@]}"; do 
# 	ansible all -i=",$server" --become -m lineinfile -a "path=/etc/yum.conf regexp='^proxy=' line='proxy=http://16.85.88.10:8080'" || true
# 	ansible all -i=",$server" --become -m shell -a "systemctl stop firewalld" || true
# 	ansible all -i=",$server" --become -m shell -a "systemctl disable firewalld" || true

# done

# wait $(jobs -p)

echo $IPADDRESSES


