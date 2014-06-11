require 'mixlib/shellout'
require 'json'

# ztrustee_org 'HW_TEST' do
#   contacts ['ian@hw-ops.com', 'cameron@hw-ops.com']
#   authcode 'secret'
# end

action :add do
  if org = get_org(new_resource.name)
    Chef::Log.info("ztrustee_org #{org['name']} exists, nothing to do")
    Chef::Log.debug("ztrustee_org #{org['name']}: #{org.inspect}")
  else
    converge_by("ztrustee_org #{new_resource.name} does not exist, adding it now") do
      add_org_command = Mixlib::ShellOut.new("#{new_resource.orgtool_path} add -n #{new_resource.name} -c #{new_resource.contacts.join(',')}")
      add_org_command.run_command
      Chef::Log.info("ztrustee_org #{new_resource.name} added!")
    end
    new_resource.updated_by_last_action(true)
  end
end

action :set_authcode do
  if org = get_org(new_resource.name)
    Chef::Log.debug("ztrustee_org #{org['name']} current authcode: #{org['auth_secret']}, requested authcode #{new_resource.authcode}")
    if org['auth_secret'] == new_resource.authcode
      Chef::Log.info("ztrustee_org #{org['name']} auth code already up to date, nothing to do.")
    else
      converge_by("ztrustee_org #{org['name']} updating authcode") do
        set_auth_command = Mixlib::ShellOut.new("#{new_resource.orgtool_path} set-auth -n #{new_resource.name} -s #{new_resource.authcode}")
        set_auth_command.run_command
      end
      new_resource.updated_by_last_action(true)
    end
  else
    Chef::Application.fatal!("ztrustee_org #{org['name']} does not exist, can't set its auth code")
  end
end

def get_orgs
  org_data = Mixlib::ShellOut.new("/usr/lib/ztrustee-server/orgtool list")
  org_data.run_command
  begin
    orgs = JSON.parse(org_data.stdout)
  rescue
    Chef::Application.fatal!("Failed to retrieve zTrustee organizations. stderr: \"#{org_data.stderr}\"")
  end
end

def get_org(name)
  orgs = get_orgs
  orgs.fetch(name, nil)
end

def list_orgs
  org_data = get_orgs
  orgs = org_data.keys
end

alias_method :action_create, :action_add

