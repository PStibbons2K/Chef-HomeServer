#
# Cookbook:: homeserver
# Recipe:: linux_basics
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

# This recipe installs the basic packages needed for the home server
# and makes sure everything is set up correctly

# check that the hostname is correct?
# TODO: Not working, this removes the domain name from /etc/hosts
#hostname 'homeserver' do
#  hostname            "#{node['main']['hostname']}"
#  ipaddress           "#{node['network']['server_ip']}"
#end

# add contrib and non-free repositories
apt_repository 'debian-main' do
  uri 		'http://ftp.de.debian.org/debian/'
  distribution	'stretch'
  components	['contrib','non-free']
  deb_src 	true
end

apt_repository 'debian-security' do
  uri		'http://security.debian.org/debian-security'
  distribution  'stretch/updates'
  components    ['contrib','non-free']
  deb_src       true
end

apt_repository 'debian-security2' do
  uri           'http://ftp.de.debian.org/debian/'
  distribution  'stretch-updates'
  components    ['contrib','non-free']
  deb_src       true
end

# Update the apt cache daily
apt_update 'daily' do
  frequency 86_400
  action :periodic
end

# install basic packages and several utilities
package 'debconf-utils'
package 'debconf-doc'
package 'unzip'
package 'build-essential'
package 'linux-headers-amd64'
package 'powertop'
package 'iotop'
package 'tcptrack'
package 'cifs-utils'
package 'ssl-cert'
package 'smartmontools'

# TODO: Get the ca certificate from somewhere trustworthy - currently it has to be placed before the first chef run!

# set correct permission for the CA certificate
file "/etc/ssl/certs/cert_ca.#{node['main']['domain']}.pem" do
  owner 'root'
  group 'root'
  mode '0644'
end

