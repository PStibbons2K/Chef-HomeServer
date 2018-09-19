#
# Cookbook:: homeserver
# Recipe:: ldapsrv
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

################################
# Prepare required environment
################################

# Install the default java runtime (should be enough for now?) and
# additional packages

package 'default-jdk'
package 'krb5-user'

# prepare Apache DS download
# TODO: replace the version numbers with a variable
# TODO: only download once?
# TODO: place in a software repository folder?

remote_file "/tmp/apacheds-2.0.0-M24-amd64.deb" do
  source "http://apache.lauf-forum.at/directory/apacheds/dist/2.0.0-M24/apacheds-2.0.0-M24-amd64.deb"
  mode 0644
end

# prepare the ssl certificates
# TODO: prepare ssl certificates

# create dnsmasq config snippet for ldapsrv.<net-name> alias name
template '/etc/dnsmasq.d/ldapsrv-dnsmasq.conf' do
  source 'ldapsrv-dnsmasq.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :restart, "service[dnsmasq]"
end

################################
# Install the directory server
################################

# install the downloaded package
dpkg_package "apacheds" do
  source "/tmp/apacheds-2.0.0-M24-amd64.deb"
  action :install
end

# replace the default config file before initial server initialization
# this is not repeatable, should the recipe rely on it?

# create a service for apacheds
service 'apacheds' do
  supports [:start, :restart, :status]
  action [:enable, :start]
end

# TODO: Configuration for the apache ds instance

# - configure admin account / password
# - enable ssl transport chain
# - disable non-ssl transport chain
# - check if all required schemata are loaded
# - reconfigure root DN
# - create and load ldif data (only if necessary!)
# - enable kerberos server
# - place krb5.conf from template



# Changes to apacheds configuration so far:
# -replace dc=example,dc=com with the "real" domain name
# - enable schemata:
#   - nis (for posixGroup and posixUser)
