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

echo "Remove VMs"

scriptPATH=$(dirname $(readlink -f $0))

. $scriptPATH/agnosticCI.conf

source $scriptPATH/$cloud_credential_file

echo " Removing VM OScon "
nova delete OScon &
echo " Removing VM Monasca "
nova delete monasca &
echo " Removing VM OpenDayLight "
nova delete odl &
echo " Removing VM Spark Master "
nova delete spark_master &
echo " Removing VM Spark slave 1 "
nova delete spark_slaves1 &
echo " Removing VM Spark slave 2 "
nova delete spark_slaves2 &
echo " Removing VM docker "
nova delete docker &
echo " Removing VM kafka "
nova delete kafka &
echo " Removing VM policy "
nova delete policy &
