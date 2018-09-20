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

package 'krb5-user'
package 'ldap-utils'
package 'slapd'

# prepare the ssl certificates
# TODO: prepare ssl certificates

# create a temp dir for ldif and other data
directory '/tmp/ldap_data' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

# put schema data ldif
template '/tmp/ldap_data/ldap_schemata.ldif' do
  source 'ldap_schemata.ldif.erb'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :run, 'execute[slapadd]', :immediately
end

execute 'slapadd' do
  command 'slapadd < /tmp/something.ldif'
  creates '/var/lib/slapd/uid.bdb'
  action :nothing
end

template '/tmp/something.ldif' do
  source 'something.ldif'
  notifies :run, 'execute[slapadd]', :immediately
end

# load schema data

# create a service, enable and start it
service 'slapd' do
  supports [:start, :restart, :status]
  action [:enable, :start]
end
