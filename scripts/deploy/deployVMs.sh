#!/bin/bash

# Author(s)     : Marouane Mechteri (Orange).
# Description   :
# Documentation :
# Funded by     : EU 5G-PPP Cognet project http://www.cognet.5g-ppp.eu/ (https://5g-ppp.eu/cognet/)
# Maintainer    : Marouane Mechteri (marouane.mechteri@orange.com), Orange
# Copyright     : Copyright 2017 Marouane Mechteri ©
# License       : Apache 2.0 ( http://www.apache.org/licenses/LICENSE-2.0.txt)
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

echo "Deploy VMs"

scriptPATH=$(dirname $(readlink -f $0))

. $scriptPATH/agnosticCI.conf

source $scriptPATH/$cloud_credential_file

$scriptPATH/os/os.sh $cloud_ubuntu16_image_id $cloud_network_id $cloud_flavor_id $cloud_key_name
sleep 5s
$scriptPATH/monasca/monasca.sh $cloud_ubuntu16_image_id $cloud_network_id $cloud_flavor_id $cloud_key_name
sleep 5s
$scriptPATH/ml/ml.sh $cloud_ubuntu16_image_id $cloud_network_id $cloud_flavor_id $cloud_key_name
sleep 5s
$scriptPATH/odl/odl.sh $cloud_ubuntu16_image_id $cloud_network_id $cloud_flavor_id $cloud_key_name
sleep 5s
$scriptPATH/docker/docker.sh $cloud_ubuntu16_image_id $cloud_network_id $cloud_flavor_id $cloud_key_name
sleep 5s
$scriptPATH/kafka/kafka.sh $cloud_ubuntu16_image_id $cloud_network_id $cloud_flavor_id $cloud_key_name
sleep 5s
$scriptPATH/policy/policy.sh $cloud_ubuntu14_image_id $cloud_network_id $cloud_flavor_id $cloud_key_name
sleep 15s
