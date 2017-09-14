. creds.sh

#!/bin/bash
set -e
set -x

servers=( kube001 kube002 kube003 )

for server in "${servers[@]}"; do 
	govc vm.destroy $server &
done

wait $(jobs -p)
