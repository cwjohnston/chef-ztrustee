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
# recipe: repo
#

require 'uri'
include_recipe 'yum-epel'

repo_uri = URI("https://archive.gazzang.com/redhat/stable/$releasever")

if node[:ztrustee][:repo_username] && node[:ztrustee][:repo_password]
  repo_uri.user = node[:ztrustee][:repo_username]
  repo_uri.password = node[:ztrustee][:repo_password]
end

yum_repository "gazzang-stable" do
  description "Gazzang stable RHEL"
  baseurl repo_uri.to_s
  gpgkey "http://archive.gazzang.com/gpg_gazzang.asc"
  action :create
end
