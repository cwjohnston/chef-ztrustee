require 'chefspec'
require 'chefspec/librarian'

describe 'ztrustee::default' do

  let(:runner)   { ChefSpec::Runner.new(platform: 'centos', version: '6.4') }
  let(:node)     { runner.node }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'configures gazzang-stable package repository' do
    expect(chef_run).to create_yum_repository('gazzang-stable')
  end

  it 'installs the ztrustee-client package' do
    expect(chef_run).to install_package('ztrustee-client')
  end

end
