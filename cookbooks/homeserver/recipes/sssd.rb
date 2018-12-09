#
# Cookbook:: homeserver
# Recipe:: sssd
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

package 'sssd'
package 'sssd-tools'

template '/etc/sssd/sssd.conf' do
  source 'sssd/sssd.conf.erb'
  mode '0600'
  owner 'root'
  group 'root'
  notifies :restart, "service[sssd]", :immediately
end

# create a service and start it
service "sssd" do
  supports [:start, :restart, :status]
  action [:enable, :start]
end

