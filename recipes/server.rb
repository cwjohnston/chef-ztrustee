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
# recipe: server

unless node[:ztrustee][:repo_username] && node[:ztrustee][:repo_password]
  Chef::Application.fatal!('I cannot install ztrustee without repo credentials (i.e. node[:ztrustee][:repo_username] and node[:ztrustee][:repo_password]')
end

include_recipe 'ztrustee::default'

group node[:ztrustee][:server_group]

user node[:ztrustee][:server_user] do
  group node[:ztrustee][:server_group]
  home node[:ztrustee][:home_dir]
end

%w( log conf server_conf home ).each do |target|
  directory node[:ztrustee]["#{target}_dir"] do
    recursive true
    owner node[:ztrustee][:server_user]
    group node[:ztrustee][:server_group]
  end
end

# the default config file is an empty pyton dict
# later steps will populate this config via ztrustee's conftool
file ::File.join(node[:ztrustee][:server_conf_dir], 'ztrustee.conf') do
  content '{}'
  owner node[:ztrustee][:server_user]
  group node[:ztrustee][:server_group]
  mode 0600
  action :create_if_missing
end

%w{ python-argparse
    pytz
    gnutls-utils
    m2crypto
    python-psycopg2
    pyOpenSSL }.each do |pkg|

  package pkg do
    action :install
  end
end

# install, enable and start entropy gathering daemon
package 'haveged'

service 'haveged' do
  action [:enable, :start]
end

package "ztrustee-server" do
  action :install
end

include_recipe 'ztrustee::_server_ssl'
include_recipe 'ztrustee::_server_apache'
include_recipe 'ztrustee::_server_postgresql'
include_recipe 'ztrustee::_server_gpg'
