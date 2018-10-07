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

# prepare ssl certificate files

# install misc tools
package 'ldap-utils'

# TODO: is this needed?
#package 'libsasl2-modules-gssapi-mit'

# install slapd package with preseeded values
# TODO: Remove Passwords, at least for production!
package 'slapd' do
  response_file 'slapd.seed'
end

# Create the service, start and enable it
service "slapd" do
  supports [:start, :restart, :status]
  action [:enable, :start]
end

# Add openLDAP user to ssl-cert group
group 'ssl-cert' do
  action :modify
  append true
  members "openldap"
end

# add dnsmasq config snippet
template '/etc/dnsmasq.d/ldapsrv-dnsmasq.conf' do
  source 'ldap/ldapsrv-dnsmasq.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :restart, "service[dnsmasq]"
end


# TODO: Set correct permissions for certificate files
file "/etc/ssl/certs/cert_ldapsrv.#{node['main']['domain']}.pem" do
  owner 'root'
  group 'root'
  mode '0644'
end

file "/etc/ssl/private/key_ldapsrv.#{node['main']['domain']}.pem" do
  owner 'root'
  group 'ssl-cert'
  mode '0640'
end

# create client config file
template '/etc/ldap/ldap.conf' do
  source 'ldap/ldap.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Load additional schema "groupofentries" to allow empty groups
cookbook_file "/etc/ldap/schema/groupfoentries.ldif" do
  source "default/ldap/schema/groupofentries.ldif"
  not_if { ::File.exist?('/etc/ldap/schema/groupfoentries.ldif') }
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, 'execute[ldapadd_groupofentries]', :immediately
end

# load ldif with changes for the cn=config tree
template '/root/modify_slapd_01.ldif' do
  source 'ldap/modify_slapd_01.ldif.erb'
  owner 'root'
  group 'root'
  mode '0600'
  notifies :restart, 'service[slapd]', :immediately
  notifies :run, 'execute[ldapadd_modify_01]', :immediately
end

# load ldif with changes for the data tree
template '/root/modify_slapd_02.ldif' do
  source 'ldap/modify_slapd_02.ldif.erb'
  owner 'root'
  group 'root'
  mode '0600'
  notifies :run, 'execute[ldapadd_modify_02]', :immediately
end

# TODO: Check if ldaps needs to be enabled via
# SLAPD_SERVICES="ldap:/// ldapi:///"
# in /etc/default/slapd

# TODO: create monitoring snippets

################################################
# executes for several templates and ldif files
################################################

execute 'ldapadd_groupofentries' do
  command 'ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/groupfoentries.ldif'
  action :nothing
end

execute 'ldapadd_modify_01' do
  command 'ldapadd -Y EXTERNAL -H ldapi:/// -c -f /root/modify_slapd_01.ldif'
  action :nothing
  returns [0,80]
end

execute 'ldapadd_modify_02' do
  command 'ldapadd -Y EXTERNAL -H ldapi:/// -c -f /root/modify_slapd_02.ldif'
  action :nothing
  returns [0,68,32]
end