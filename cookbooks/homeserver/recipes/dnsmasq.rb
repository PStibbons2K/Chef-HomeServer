#
# Cookbook:: homeserver
# Recipe:: dnsmasq
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

# install the dnsmasq package
package 'dnsmasq'

# Set the dns server in resolv.conf to the server ip as
# soon as the service is up
#template '/etc/resolv.conf' do
#  source 'dnsmasq/resolv.conf.erb'
#  owner 'root'
#  group 'root'
#  mode '0644'
#  notifies :restart, "service[dnsmasq]", :immediately
#end

# create the static host mapping config
# TODO: Add a check or guard to prevent template file if no static host is defined
template '/etc/dnsmasq.d/static-dnsmasq.conf' do
  source 'dnsmasq/dnsmasq_static.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
  variables ( {:static_hosts => node['network']['dhcp']['static_hosts'] } )
  notifies :restart, "service[dnsmasq]", :immediately
end

# copy the configuration template
template '/etc/dnsmasq.conf' do
  source 'dnsmasq/dnsmasq.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :restart, "service[dnsmasq]", :immediately
end

# replace the resolver config
template '/etc/resolv.conf' do
  source 'dnsmasq/resolv.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[dnsmasq]", :immediately
end

# create a service and start it
service "dnsmasq" do
  action [:enable, :start]
end