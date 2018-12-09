#
# Cookbook:: homeserver
# Recipe:: hardware
#
# Copyright:: 2018, Martin Zimmermann
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##################
# APC UPS Daemon
##################

# package installation
package 'apcupsd'

# create a service and start it
service "apcupsd" do
  action [:enable, :start]
end

# copy the configuration template
template '/etc/apcupsd/apcupsd.conf' do
  source 'apcupsd.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :restart, "service[apcupsd]"
end

###########################################
# LM Sensors package and hardware modules
##########################################

# package installation
package 'lm-sensors'
package 'patch'

# TODO: Check if there are any firmware modules to build
# for the FTS Teutates module on 3417-B? Still needed? Old instructions below:
# Load i2c stuff: "modprobe i2c_i801"
# - get teutates source from ftp://ftp.ts.fujitsu.com/pub/Mainboard-OEM-Sales/Services/Software&Tools/Linux_SystemMonitoring&Watchdog&GPIO/ftsteutates-module_20160601.zip
# - unzip source
# - compile ftsteutates kernel module
# - run sensors-detect
# - modify /etc/modules
# TODO: New - possibly the config file for lmsensors is enough?

#patch /usr/sbin/sensors-detect /home/ladmin/assets/add-fts-teutates-to-lm-sensors-detect.patch
#https://hirnfasching.de/2016/08/02/monitoring-eines-fujitsu-d3417-b1-unter-debian-jessie/
#----cut here----
 # Chip drivers
 #coretemp
 #ftsteutates
 #jc42

# TODO: check if sensors-detect can be run here? - if not, run manually

##################################################
# other hardware modules - e.g. missing firmware
##################################################

package 'firmware-misc-nonfree'