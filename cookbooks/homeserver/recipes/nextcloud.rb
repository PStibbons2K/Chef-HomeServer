#
# Cookbook:: homeserver
# Recipe:: nextcloud
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


# Get the installation package for the required version
# URL example: https://download.nextcloud.com/server/releases/nextcloud-14.0.3.zip

#TODO: Change version to a variable
#remote_file '/datastore/software/Applikationen/NextCloud/nextcloud-14.0.3.zip' do
#  source 'https://download.nextcloud.com/server/releases/nextcloud-14.0.3.zip'
#  owner 'www-data'
#  group 'www-data'
#  mode '0755'
#  action :create
#end