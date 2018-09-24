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

# TODO: Add package name and/or version string as variables?

package 'krb5-user'
package 'ldap-utils'

remote_file "/tmp/apacheds-2.0.0-M24-amd64.deb" do
  source "http://apache.lauf-forum.at/directory/apacheds/dist/2.0.0-M24/apacheds-2.0.0-M24-amd64.deb"
  mode 0644
end

# prepare the ssl certificates
# TODO: prepare ssl certificates

# install downloaded package
dpkg_package "apacheds" do
  source "/tmp/apacheds-2.0.0-M24-amd64.deb"
  action :install
end

# check if the config file has already been read - file name changes from config.ldif to config.ldif_migrated
# if not migrated yet replace with our template, otherwise this step has happened already
# after the initial setup script all further changes need to be done via ldif files

#template '/<PATH>/config.ldif' do
#  not_if { ::File.exist?('/<PATH>/config.ldif_migratedl') }
#  source 'ldap_config.ldif.erb'
#  owner 'root'
#  group 'root'
#  mode '0640'
#end

# create a service and enable / start it
service 'apacheds' do
  supports [:start, :restart, :status]
  action [:enable, :start]
end

# Required changes to the default config.ldif file
# ** ads-dsallowanonymousaccess: TRUE
# -> ads-dsallowanonymousaccess: FALSE
# ** dn: ads-partitionId=example,ou=partitions,ads-directoryServiceId=default,ou=config
# -> dn: ads-partitionId=example,ou=partitions,ads-directoryServiceId=default,ou=config
# ** ads-partitionSuffix: dc=example,dc=com
# -> ads-partitionSuffix: dc=test,dc=intra,dc=zimmermann,dc=family
# ** ads-partitionid: example
# -> ads-partitionid: test-intra
# replace all other hits for "ads-partitionId=example" with "ads-partitionId=test-intra"
# base64 encoding is needed for a part of the informations
# see https://directory.apache.org/apacheds/basic-ug/1.4.3-adding-partition.html
# TODO: enable needed schemata here or in specific recipes?
# Schema are here: DN: cn=nis,ou=schema
