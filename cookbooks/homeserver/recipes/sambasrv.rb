#
# Cookbook:: homeserver
# Recipe:: sambasrv
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


# install required packages
package 'samba'
package 'smbldap-tools'
package 'smbclient'
package 'winbind'
package 'msktutil'

# create kerberos principal
execute 'create_samba_principal' do
  # TODO: Add a guard
  command "kadmin.local -q \"addprinc -randkey cifs/#{node['main']['hostname']}.#{node['main']['domain']}@#{node['kerberos']['realm']}\""
end

# create samba keytab
execute 'create_samba_keytab' do
  # TODO: replace rc4-hmac with something newer?
  command "kadmin.local -q \"ktadd -k /var/lib/samba/private/krb5.keytab -e rc4-hmac:normal cifs/#{node['main']['hostname']}.#{node['main']['domain']}@#{node['kerberos']['realm']}\""
  not_if { ::File.exist?('/var/lib/samba/private/krb5.keytab') }
end

# set permissions for the keytab file
#file

# create samba config file
template '/etc/samba/smb.conf' do
  source 'sambasrv/smb.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[smbd]', :immediately
end

# samba service
service 'smbd' do
  supports [:start, :restart, :status]
  action [:enable, :start]
end

# run samba as simple file server or as active directory server?
# dc provision would be:
# #samba-tool domain provision --use-rcf2307 --realm test.intra.zimmermann.family --domain test --server-role=dc --dns-backend=SAMBA_INTERNAL --adminpass=P@ssw0rd
