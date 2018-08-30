#
# Cookbook:: homeserver
# Recipe:: sambasrv
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



# run samba as simple file server or as active directory server?
# dc provision would be:
# #samba-tool domain provision --use-rcf2307 --realm test.intra.zimmermann.family --domain test --server-role=dc --dns-backend=SAMBA_INTERNAL --adminpass=P@ssw0rd
