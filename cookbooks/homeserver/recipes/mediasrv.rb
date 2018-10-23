#
# Cookbook:: homeserver
# Recipe:: mediasrv
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

# install required package(s)
package 'minidlna'

# set up dns alias
template '/etc/dnsmasq.d/mediasrv-dnsmasq.conf' do
  source 'mediasrv/mediasrv-dnsmasq.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :restart, "service[dnsmasq]", :immediately
end

# create a service
service "minidlna" do
  supports [:start, :restart, :status]
  action [:enable, :start]
end

# replace config file and restart the service
template '/etc/minidlna.conf' do
  source 'mediasrv/minidlna.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[minidlna]", :immediately
end