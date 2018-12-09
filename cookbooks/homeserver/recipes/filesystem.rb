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

# ZFS needs build stuff and dkms for kernel modules
package 'dkms'

# install zfs on linux package
package 'zfsutils-linux' do
  action :install
  options "--assume-yes"
end

# create zpool if not yet there
# guard could be zpool list -Ho name <name>
# ladm@homesrv:~$ sudo zpool list -Ho name blobb
#cannot open 'blobb': no such pool
#ladm@homesrv:~$ echo $?
#return value for non-existant pool is "1"
#zpool params:
# - disk ids
# - 4k-Block-Switch
# - raid type (default should be raidz1?)

#execute 'create_zpool' do
#  command "zpool"
#  not_if
#end

# create L2ARC cache if configured (variable?)
# see https://pthree.org/2012/12/07/zfs-administration-part-iv-the-adjustable-replacement-cache/

# enable compression for the complete zfs pool
execute "zfs_enable_compression" do
  command "zfs set compression=lz4 datastore"
  not_if "zfs get compression datastore | grep lz4"
end

# create datasets according to structure
# TODO: add something more elegant!
execute "zfs_create_datasets_homes" do
  command "zfs create datastore/homes"
  not_if "zfs list datastore/homes"
end

execute "zfs_create_datasets_media" do
  command "zfs create datastore/media"
  not_if "zfs list datastore/media"
end

execute "zfs_create_datasets_backup" do
  command "zfs create datastore/backup"
  not_if "zfs list datastore/backup"
end

execute "zfs_create_datasets_documents" do
  command "zfs create datastore/documents"
  not_if "zfs list datastore/documents"
end

execute "zfs_create_datasets_server" do
  command "zfs create datastore/server"
  not_if "zfs list datastore/server"
end

execute "zfs_create_datasets_software" do
  command "zfs create datastore/software"
  not_if "zfs list datastore/software"
end

# Install snapshot package after initial setup for the zfs pool
# zfs-auto-snapshot is also creating cronjobs for snapshots!
# should the "keep"-amount be configurable? if yes - add templates?
#package 'zfs-auto-snapshot'