. creds.sh

#!/bin/bash
set -e
set -x

servers=( kube001 kube002 kube003 )

for server in "${servers[@]}"; do 
	govc vm.clone -vm DXC-UBUNTU16.04-KUBERNETES -customization=$server -ds ukrd_esx_mgmt_data_002 -net DMZ_Internet_Vlan201 $server &
done

wait $(jobs -p)
