#
# Cookbook:: homeserver
# Recipe:: default
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

# Step 01 - Linux basics
include_recipe 'homeserver::linux_basics'

# Step 01b - Hardware dependent packages
include_recipe 'homeserver::hardware'

# Step 02 - ZFS filesystem
include_recipe 'homeserver::filesystem'

# Step 02 - DNSMasq DNS/DHCP server
include_recipe 'homeserver::dnsmasq'

# Step 03 - NTP timeserver
include_recipe 'homeserver::ntpsrv'