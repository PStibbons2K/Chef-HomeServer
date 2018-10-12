#
# Cookbook:: homeserver
# Recipe:: ntpsrv
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
package 'ntp'

# create a service and start it
service "ntp" do
  supports [:start, :restart, :status]
  action [:enable, :start]
end

# create dnsmasq config snippet for ntpd.<net-name> alias name
template '/etc/dnsmasq.d/ntpd-dnsmasq.conf' do
  source 'ntpd-dnsmasq.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :restart, "service[dnsmasq]"
end