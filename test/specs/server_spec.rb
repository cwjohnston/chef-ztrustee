require 'chefspec'
require 'chefspec/librarian'
require 'chefspec/server'

describe 'ztrustee::server' do

  let(:runner)   { ChefSpec::Runner.new(platform: 'centos', version: '6.4') }
  let(:node)     { runner.node }
  let(:chef_run) { runner.converge(described_recipe) }

  before do
    node.set[:ztrustee][:repo_username] = 'foo'
    node.set[:ztrustee][:repo_password] = 'bar'
  end

  it 'raises an exception when repository credentials are not provided' do
    node.set[:ztrustee][:repo_username] = nil
    expect{ chef_run }.to raise_error
  end

  it 'installs postgresql server via community cookbook' do
    expect(chef_run).to include_recipe('postgresql::server_redhat')
  end

  it 'installs apache2 server and modules via community cookbook' do
    %w{ default mod_ssl mod_rewrite mod_wsgi mod_proxy_http}.each do |r|
      expect(chef_run).to include_recipe("apache2::#{r}")
    end
  end

  it 'installs required python packages' do
    %w{ python-argparse
        pytz
        gnutls-utils
        m2crypto
        python-psycopg2
        pyOpenSSL
      }.each do |pkg|
        expect(chef_run).to install_package(pkg)
      end
  end

  it 'installs the entropy gathering daemon' do
    expect(chef_run).to install_package('haveged')
  end

  it 'enables and starts the entropy gathering daemon' do
    expect(chef_run).to enable_service('haveged')
    expect(chef_run).to start_service('haveged')
  end

  it 'configures ztrustee package repository' do
    expect(chef_run).to create_yum_repository('gazzang-stable')
  end

  it 'installs the ztrustee-server package' do
    expect(chef_run).to install_package('ztrustee-server')
  end

  it 'execute multiple post-installation scripts' do
    %w{ common database mail hkp web }.each do |component|
      expect(chef_run).to run_execute("ztrustee-postinstall-#{component}")
    end
  end

end
