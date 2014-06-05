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

require 'serverspec'
require 'open-uri'
require 'openssl'
require 'json'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

ztrustee_home = '/var/lib/ztrustee'
ztrustee_conf_dir = ::File.join(ztrustee_home, '.ztrustee')
orgtool_path = '/usr/lib/ztrustee-server/orgtool'

describe file(::File.join(ztrustee_conf_dir, 'ztrustee.conf')) do
  it { should be_file }
end

describe port(25) do
  it { should be_listening.with('tcp') }
end

describe port(80) do
  it { should be_listening.with('tcp') }
end

describe port(443) do
  it { should be_listening.with('tcp') }
end

response = open('https://localhost/?a=fingerprint',
                :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read

fingerprint = response.split('/')

describe fingerprint do
  it { should have_exactly(2).items }
end

orgtool_output = command("#{orgtool_path} list").stdout

describe orgtool_output do
  it { should match(/test_org/) }
end
