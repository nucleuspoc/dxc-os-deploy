#!/bin/bash
. creds.sh


set -e
set -x

servers=( k01001 k01002 k01003 k01004 k01005 )

for server in "${servers[@]}"; do 
	govc vm.destroy $server &
done

wait $(jobs -p)
