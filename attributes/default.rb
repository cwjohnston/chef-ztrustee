#
# Author:: Heavy Water Operations, LLC <support@hw-ops.com>
#
# Copyright 2014, Heavy Water Operations, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default[:ztrustee][:server_user] = 'ztrustee'
default[:ztrustee][:server_group] = 'ztrustee'
default[:ztrustee][:server_email] = 'admin@example.com'
default[:ztrustee][:server_url] = 'https://ztrustee.gazzang.com'
default[:ztrustee][:repo_username] = nil
default[:ztrustee][:repo_password] = nil
default[:ztrustee][:home_dir] = '/var/lib/ztrustee'
default[:ztrustee][:log_dir] = '/var/log/ztrustee'
default[:ztrustee][:conf_dir] = '/etc/ztrustee'
default[:ztrustee][:server_conf_dir] = '/var/lib/ztrustee/.ztrustee'
default[:ztrustee][:database][:db_name] = 'ztrustee'
default[:ztrustee][:database][:host] = 'localhost'
default[:ztrustee][:database][:user] = 'ztrustee'
default[:ztrustee][:database][:password] = nil
