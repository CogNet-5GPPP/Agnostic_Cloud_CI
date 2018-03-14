#!/bin/bash

# Author(s)    : Joe Tynan (WIT), Siblee Islam (WIT).
# Description    :
# Documentation :
# Funded by    : EU 5G-PPP Cognet project http://www.cognet.5g-ppp.eu/ (https://5g-ppp.eu/cognet/)
# Maintainer    : Joe Tynan (jtynan@tssg.org), Waterford Institute of Technology
# Copyright    : Copyright 2016 Waterford Institute of Technology ©
# License    : Apache 2.0 ( http://www.apache.org/licenses/LICENSE-2.0.txt)
# Licensed under the Apache License, Version 2.0 (the "License");
#
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Modified work Copyright 2017 Marouane Mechteri
# Author: Marouane Mechteri (marouane.mechteri@orange.com), Orange

# Script to extract data from cloud infra


VMlist=(
        'spark_master'   '0.0.0.0'
        'spark_slaves1'   '0.0.0.0'
        'spark_slaves2'   '0.0.0.0'
        'oscon'      '0.0.0.0'
        'odl'     '0.0.0.0'
        'monasca' '0.0.0.0'
        'docker' '0.0.0.0'
        'kafka' '0.0.0.0'
        'policy' '0.0.0.0'
       );


echo "Create Ansible inventory file and hosts template for CogNet VMs"

scriptPATH=$(dirname $(readlink -f $0))

. $scriptPATH/../../../deploy/agnosticCI.conf

source $scriptPATH/../../../deploy/$cloud_credential_file

AnsibleHostFile=$scriptPATH/../inventory
## [Marouane Mechteri]: update the name of the inventory file
AnsibleHostFileBootStrap=$scriptPATH/hostsBootStrap
AnsibleHostList=$scriptPATH/HostList
User=cognet
pubIP=0.0.0.0
priIP=0.0.0.0
CheckTimeInt=40
NovaListReturn="$(nova list)"

while [[ $NovaListReturn == *"spawning"* ]]
do
  VMSpawningCount=$(grep -o "spawning" <<< "$NovaListReturn" | wc -l);
  echo "`date -u` VM's still in spawing state : $VMSpawningCount";
  sleep $CheckTimeInt;
  NovaListReturn="$(nova list)"
done


function initFiles {
    echo "# List of Cognet hosts" > $AnsibleHostFile
    echo "" >> $AnsibleHostFile
    echo "# List of Cognet hosts" > $AnsibleHostFileBootStrap
    echo "" >> $AnsibleHostFileBootStrap
    #echo "" > $AnsibleKnownHost
    # [Marouane Mechteri] we should check that .bashrc and .ssh/known_hosts files are already created
    touch ~/.ssh/known_hosts || exit
    touch ~/.bashrc || exit
    echo "" > $AnsibleHostList
    echo "# List of CogNet hosts" >> $AnsibleHostList
    echo "" >> $AnsibleHostList
}

function writeToFile {
    echo -e "$hostname ansible_user='$User' ansible_ssh_host=$pubIP ansible_ssh_private_key_file=~/.ssh/id_rsa" >> $1
}

function writeTagToFile {
    echo -e $1 >> $2
}

function writeToEnvFile {
    echo -e "$hostname: $priIP" >> $1
}

for((n=0;n<${#VMlist[@]};n++)); do

    if (( $((n % 2 )) == 0 )); then
        if (( (n) == 0 )); then
            initFiles
        fi
    fi
    hostname=${VMlist[$n]}
    echo hostname :  $hostname
    novashowreturn="$(nova show $hostname)"
    echo novashowreturn: $novashowreturn
    if [ -n "$novashowreturn" ]; then
   
#    findIPaddress $novashowreturn
# [Marouane Mechteri] getting the public address from openstack/openwatt is different from rackspace
#              pubIP="$(echo -e "$novashowreturn" | 'grep' "accessIPv4" | 'awk' '{ print $4}' )"
                pubIP="$(echo -e "$novashowreturn" | 'grep' "network" | 'awk' '{ print $6}' )"

                # [Marouane Mechteri] delete comma ',' from the IP address
               priIP="$(echo -e "$novashowreturn" | 'grep' "network" | 'awk' '{ print $5}' | cut -d, -f1 )"

        VMlist[$n+1]=$pubIP

        echo PublicIP $pubIP
        echo PrivateIP $priIP

            if [[ $hostname == *"spark_slaves"* ]]
            then
                if ! grep -Fxq "[spark_slaves]" $AnsibleHostFile
                then
                    writeTagToFile "\n[spark_slaves]" $AnsibleHostFile
                    writeTagToFile "\n[spark_slaves]" $AnsibleHostFileBootStrap
                fi
            else
                writeTagToFile "\n[$hostname]" $AnsibleHostFile
                writeTagToFile "\n[$hostname]" $AnsibleHostFileBootStrap
            fi

        if [[ $hostname == *"spark_slaves"* ]]
               then
                       sed -i '/\[spark_slaves\]/a '$hostname' ansible_user='$User' ansible_ssh_host='$pubIP' ansible_ssh_private_key_file=~/.ssh/id_rsa' $AnsibleHostFile
                        sed -i '/\[spark_slaves\]/a '$hostname' ansible_ssh_host='$pubIP' ansible_ssh_private_key_file=~/.ssh/id_rsa' $AnsibleHostFileBootStrap
            sed -i '/export '$hostname'/c\export '$hostname'='$pubIP'' ~/.bashrc
                echo -e "$pubIP $hostname " >> $AnsibleHostList
               else
                        echo -e "$hostname ansible_user=$User ansible_ssh_host=$pubIP ansible_ssh_private_key_file=~/.ssh/id_rsa" >> $AnsibleHostFile
                echo -e "$hostname ansible_ssh_host=$pubIP ansible_ssh_private_key_file=~/.ssh/id_rsa" >> $AnsibleHostFileBootStrap
            sed -i '/export '$hostname'/c\export '$hostname'='$pubIP'' ~/.bashrc
                echo -e "$pubIP $hostname " >> $AnsibleHostList

        fi

        if [ "$pubIP" ]; then
            ssh-keyscan  $pubIP >> ~/.ssh/known_hosts
        fi

    fi
    n=$n+1
done

echo -e " ">> $AnsibleHostFile
echo -e "[monasca-agent:children] ">> $AnsibleHostFile
echo -e "oscon ">> $AnsibleHostFile
echo -e "monasca ">> $AnsibleHostFile





# to check all hosts are on line

# [Marouane Mechteri] changed from root to ubuntu since the default user in the VM is ubuntu
#ansible all -m ping -u root -i $AnsibleHostFileBootStrap
#ansible all -m ping -u ubuntu -i $AnsibleHostFileBootStrap
sleep 10
