<img src="https://www.openshift.com/images/logos/openshift/Logotype_RH_OpenShift_wLogo_RGB_Gray.png" width="300"/> 

# DXC OpenShift Deployment
This repository contains the relevant files in order to complete an automated deployment of RedHat Openshift using Ansible. 

## Prerequisites 
This repository is assuming you already have 
- A RedHat license to deploy Openshift 
- A Linux machine with Ansible installed

## Folders and files
Throughout this repository, there are many different files at hand however the only ones we would need to use are:
- 'ocp-hosts': The hosts file with variables for this repository
- 'openshift-level1.yml': Removes any guests and creates the Virtual Machine for OpenShift
- 'openshift-level2yml': Creates all the Openshift nodes along with install all relevant software required for Openshift to work
- 'control-machine.yml': Copies ssh keys, creates hosts, ldap and config files as well as the final configuration to the nodes. The last two tasks creates a project in OpenShift

There are a couple of methods in executing these playbooks. The first method has been currently tested successfully by the PoC team, however the second was written by George Cairns prior to him leaving
#### Option 1
```yml
$ ansible-playbook --extra-vars="vcuser=cairnsg@dbpoc.uk vcpass=Cr4mpulations" openshift-level1.yml
$ ansible-playbook -i ocp-hosts  --extra-vars="rhpass=F.remulon12" openshift-level2.yml
$ ansible-playbook -i ocp-hosts control-machine.yaml --extra-vars="dxc_dn=dc=dbpoc,dc=uk dxc_domain=dbpoc.uk openshift_ldap_password=Start123"
```
#### Option two
```yml
$ ansible-playbook --extra-vars="vcuser=cairnsg@dbpoc.uk vcpass=Cr4mpulations" -i ocp-hosts openshift-level1.yml ; sleep 1 &&ansible-playbook -i ocp-hosts  --extra-vars="rhpass=F.remulon12" openshift-level2.yml &&ansible-playbook -i ocp-hosts control-machine.yaml --extra-vars="dxc_dn=dc=dbpoc,dc=uk dxc_domain=dbpoc.uk openshift_ldap_password=Start123"
```
