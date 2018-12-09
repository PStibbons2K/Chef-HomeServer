#
# Cookbook:: homeserver
# Recipe:: mariadb
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

#########
# MariaDB installation recipe
# Description: TBD
# should listen on socket/localhost only
#
########

# install package
package 'mariadb-server'

# prepare ssl certificates for mariadb

# create a service and start it
service "mariadb" do
  action [:enable, :start]
end

# create dnsmasq config snippet for dbsrv.<net-name> alias name
template '/etc/dnsmasq.d/dbsrv-dnsmasq.conf' do
  source 'dbsrv-dnsmasq.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :restart, "service[dnsmasq]"
end

# create config file
#template '/etc/mysql/mariadb.conf.d/50-server.cnf' do
#  source 'mariadb/mariadb-50-server.cnf.erb'
#  owner 'root'
#  group 'root'
#  mode '0644'
#  notifies :restart, "service[mariadb]"
#end

# TODO: create backup folder, place backup script and add crontab entry


# TODO: add monitoring checks after checking the folder for icinga2 checks
