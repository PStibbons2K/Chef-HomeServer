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

# TODO: StartTLS config for the ldap connection has to be set in the database
#MariaDB [nextcloud]> UPDATE oc_appconfig SET configvalue = "1" WHERE appid='user_l                                                                                                                                                        dap' AND configkey = 'ldap_tls';
#Query OK, 1 row affected (0.01 sec)
#Rows matched: 1  Changed: 1  Warnings: 0
#
#MariaDB [nextcloud]> select * from oc_appconfig WHERE appid = 'user_ldap' AND conf                                                                                                                                                        igkey = 'ldap_tls';
#+-----------+-----------+-------------+
#| appid     | configkey | configvalue |
#+-----------+-----------+-------------+
#| user_ldap | ldap_tls  | 1           |
#+-----------+-----------+-------------+

