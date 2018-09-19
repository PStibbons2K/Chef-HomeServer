#
# Cookbook:: homeserver
# Recipe:: websrv
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

# prepare main ssl certificates (app certificates are installed in the
# recipes for the applications)

# install package(s)
package 'apache2'

# create a service, enable and start it
service 'apache2' do
  supports [:start, :restart, :reload, :status]
  action [:enable, :start]
end

# enable needed modules (build a list variable for this?)
# this currently triggers a restart even if the module is already loaded - should be changed!
# better: Check if /mods-enabled already contains a symlink to [module].load?
execute "a2enmod ssl" do
  command "/usr/sbin/a2enmod #{params[:name]}"
  notifies :restart, 'service[apache2]', :delayed
end
