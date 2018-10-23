#
# Cookbook:: homeserver
# Recipe:: filesystem
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

# install zfs on linux package
package 'zfsutils-linux' do
  action :install
  options "--assume-yes"
end



# zfs-dkms needs a "yes"?
# zfs-auto-snapshot is also creating cronjobs for snapshots!
# should the "keep"-amount be configurable? if yes - add templates?


# Install snapshot package after initial setup for the zfs pool
#package 'zfs-auto-snapshot'