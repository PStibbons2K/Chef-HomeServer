#
# Cookbook:: homeserver
# Recipe:: kerberos
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

package 'krb5-user'
package 'krb5-doc'
package 'krb5-kdc'
package 'krb5-admin-server'
package 'krb5-kdc-ldap'

# prepare configuration files
template '/etc/krb5.conf' do
  source 'kerberos/krb5.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/krb5kdc/kdc.conf' do
  source 'kerberos/kdc.conf.erb'
  owner 'root'
  group 'root'
  mode '0600'
end

# Load the ldap schema for krb5 backend
# the required ldif file is part of krb5-kdc-ldap and can be found here:
# /usr/share/doc/krb5-kdc-ldap/kerberos.schema.gz
# there is no simple way to unzip/copy a file with chef,
# so the file is added to the "files" section in the cookbook
# this is not upgrade safe!
# procedure to generate a working ldif file is described here:
# https://debianforum.de/forum/viewtopic.php?t=170334&start=15

cookbook_file "/etc/ldap/schema/kerberos.ldif" do
  not_if { ::File.exist?('/etc/ldap/schema/kerberos.ldif') }
  source "default/ldap/schema/kerberos.ldif"
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, 'execute[ldapadd]', :immediately
end

execute 'ldapadd' do
  command 'ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/kerberos.ldif'
  action :nothing
end

# create base ou in ldap tree
#template

# create a new krb5 domain
# TODO: Only try this once, services need to be stopped?
