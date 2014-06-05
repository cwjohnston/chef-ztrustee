require 'mixlib/shellout'
require 'json'

# ztrustee_org 'HW_TEST' do
#   contacts ['ian@hw-ops.com', 'cameron@hw-ops.com']
# end

action :add do
  if org = get_org(new_resource.name)
    Chef::Log.info("ztrustee_org #{org['name']} exists, nothing to do")
    Chef::Log.debug("ztrustee_org #{org['name']}: #{org.inspect}")
  else
    Chef::Log.info("ztrustee_org #{new_resource.name} does not exist, adding it now")
    add_org_command = Mixlib::ShellOut.new("#{new_resource.orgtool_path} add -n #{new_resource.name} -c #{new_resource.contacts.join(',')}")
    add_org_command.run_command
    Chef::Log.info("ztrustee_org #{new_resource.name} added!")
    org = get_org(new_resource.name)
    Chef::Log.debug("ztrustee_org #{org['name']}: #{org.inspect}")
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

