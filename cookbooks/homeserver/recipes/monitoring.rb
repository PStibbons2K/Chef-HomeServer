#
# Cookbook:: homeserver
# Recipe:: monitoring
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

# add icinga2 package source
apt_repository 'icinga2-main' do
  uri 		'http://packages.icinga.com/debian'
  distribution	'icinga-stretch'
  components	['main']
  deb_src 	true
  key 'https://packages.icinga.com/icinga.key'
end

# install required packages
package 'icinga2'
package 'icingaweb2'
package 'monitoring-plugins'

package 'php-gd' do
  action :install
  notifies :restart, 'service[apache2]', :immediately
end

# Icingaweb2 requirements:
#addgroup --system icingaweb2;
# usermod -a -G icingaweb2 www-data;
# If you've got the IcingaCLI installed you can do the following:

group 'icingaweb2' do
  append true
  system true
  members 'www-data'
end

# icingacli setup config directory --group icingaweb2;
# icingacli setup token create;

# Add icingaweb2 site instead of the config - /icingaweb2 should not be available on all vhosts?
#/etc/apache2/sites-available/icingaweb2.conf