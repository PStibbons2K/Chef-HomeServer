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

# create client config file
template '/etc/ldap/ldap.conf' do
  source 'ldap.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# put additional schema files and load them
cookbook_file "/etc/ldap/schema/groupfoentries.ldif" do
  source "default/ldap/schema/groupofentries.ldif"
  not_if { ::File.exist?('/etc/ldap/schema/groupfoentries.ldif') }
  owner 'root'
  group 'root'
  mode '0644'
  #notifies :run, 'execute[ldapadd_groupofentries]', :immediately
end

cookbook_file "/etc/ldap/schema/rfc2307bis.schema" do
  not_if { ::File.exist?('/etc/ldap/schema/rfc2307bis.schema') }
  source "default/ldap/schema/rfc2307bis.schema"
  owner 'root'
  group 'root'
  mode '0644'
  #notifies :run, 'execute[ldapadd]', :immediately
end



# create basic structure
template '/root/ldap_modify.ldif' do
  source 'ldap_modify.ldif.erb'
  owner 'root'
  group 'root'
  mode '0600'
  #notifies :run, 'execute[ldapadd_modify]', :immediately
end

# # Modify NIS schema - posixGroup should be auxiliary

# set ACLs

# create basic structure

# set TLS parameters



# executes for several templates and ldif files

execute 'ldapadd_groupofentries' do
  command 'ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/groupfoentries.ldif'
  action :nothing
end

execute 'ldapadd_rfc2307bis' do
  command 'ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/rfc2307bis.schema'
  action :nothing
end

execute 'ldapadd_modify' do
  command 'ldapadd -Y EXTERNAL -H ldapi:/// -f /root/ldap_modify.ldif'
  action :nothing
end