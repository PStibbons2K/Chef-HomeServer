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

template '/etc/krb5kdc/kadm5.acl' do
  source 'kerberos/kadm5.acl.erb'
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
  notifies :run, 'execute[ldapadd_schema]', :immediately
end

execute 'ldapadd_schema' do
  command 'ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/kerberos.ldif'
  action :nothing
end

# load the structure and users required for kerberos
template '/root/krb_dataset.ldif' do
  source 'kerberos/krb_dataset.ldif.erb'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :run, 'execute[ldapadd_data]', :immediately
end

execute 'ldapadd_data' do
  command 'ldapadd -Y EXTERNAL -H ldapi:/// -f /root/krb_dataset.ldif'
  action :nothing
  returns [0,68,32]
end

# Create kerberos domain
# do it only if "kdb5_ldap_util view -r TEST.INTRA.ZIMMERMANN.FAMILY" returns != 0 - otherwise the domain is already there
# TODO: Replace the password entries
execute 'create_krb5_domain' do
  command "echo 'P@ssw0rd\nP@ssw0rd\n' |kdb5_ldap_util create -D cn=admin,#{node['ldap']['domain']} -w P@ssw0rd -r #{node['kerberos']['realm']} -s -sscope sub -subtrees ou=users,#{node['ldap']['domain']}"
  sensitive true
  not_if "kdb5_ldap_util view -r #{node['kerberos']['realm']}"
end

# sample for piping data into script:
# command "echo '#{node['krb5']['master_password']}\n#{node['krb5']['master_password']}\n' | kdb5_util -r #{default_realm} create -s"

service 'krb5-admin-server' do
  supports [:start, :restart, :status]
  action [:enable, :start]
  subscribes :reload, 'file[/etc/krb5.conf]', :immediately
  subscribes :reload, 'file[/etc/krb5kdc/kdc.conf]', :immediately
  subscribes :reload, 'file[/etc/krb5kdc/kadm5.acl]', :immediately
end

service 'krb5-kdc' do
  supports [:start, :restart, :status]
  action [:enable, :start]
  subscribes :reload, 'file[/etc/krb5.conf]', :immediately
  subscribes :reload, 'file[/etc/krb5kdc/kdc.conf]', :immediately
  subscribes :reload, 'file[/etc/krb5kdc/kadm5.acl]', :immediately
end

# Stash password for kdc user
# should this really be executed each time? What about password changes? A simple
# not_if / grep combination would not work?
execute 'stash_kdc_pwd' do
  command "echo 'P@ssw0rd\nP@ssw0rd\nP@ssw0rd\n' |kdb5_ldap_util stashsrvpw -D cn=admin,#{node['ldap']['domain']} -f /etc/krb5kdc/service.keyfile cn=kdc,cn=kerberos,ou=services,#{node['ldap']['domain']}"
  sensitive true
end

# Stash password for kadmind user
# should this really be executed each time? What about password changes? A simple
# not_if / grep combination would not work?
execute 'stash_kadmind_pwd' do
  command "echo 'P@ssw0rd\nP@ssw0rd\nP@ssw0rd\n' |kdb5_ldap_util stashsrvpw -D cn=admin,#{node['ldap']['domain']} -f /etc/krb5kdc/service.keyfile cn=kadmind,cn=kerberos,ou=services,#{node['ldap']['domain']}"
  sensitive true
end

execute 'create_ldap_principal' do
  command "kadmin.local -q \"addprinc -randkey ldap/ldapsrv.#{node['ldap']['domain']}@#{node['kerberos']['realm']}\""
end

execute 'create_host_principal' do
  command "kadmin.local -q \"addprinc -randkey host/#{node['main']['hostname"']}.#{node['ldap']['domain']}@#{node['kerberos']['realm']}\""
end

#<--- OLD bash scripts for reference --->


# Set LDAP permissions to allow write access to krb userkeys

# Create LDAP and host principal for server and save to keytab

#echo "--> Adding krb principal for ldap and host on server ${SERVER_NAME}"
#kadmin.local -q "addprinc -randkey ldap/ldapsrv.test.intra.zimmermann.family@TEST.INTRA.ZIMMERMANN.FAMILY"
#kadmin.local -q "addprinc -randkey host/homesrv.test.intra.zimmermann.family@TEST.INTRA.ZIMMERMANN.FAMILY"

#echo "--> Saving LDAP principal in keytab file"
#kadmin.local -q "ktadd -k /etc/ldap/krb5.keytab ldap/${SERVER_NAME}.${DNS_REALMNAME}@${KRB5_REALMNAME}"
#chown openldap:openldap /etc/ldap/krb5.keytab#

#echo "--> Saving host principal in keytab file"
#kadmin.local -q "ktadd -k /etc/krb5.keytab host/${SERVER_NAME}.${DNS_REALMNAME}@${KRB5_REALMNAME}"

# Set keytab name for GSSAPI
#echo "--> Setting keytab name for slapd"
#sed -ie 's|^.*KRB5_KTNAME.*$|export KRB5_KTNAME=/etc/ldap/krb5.keytab|' /etc/default/slapd

#echo "--> Starting kdc service"
#/etc/init.d/krb5-kdc start

#echo "--> Restarting slapd service to enable kerberos integration"
#systemctl restart slapd
