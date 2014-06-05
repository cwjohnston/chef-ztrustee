def load_current_resource
  @current_resource = Chef::Resource::ZtrusteeConf.new(@new_resource.name)
  @current_resource.conftool(@new_resource.conftool)
  @current_resource.conf_file(@new_resource.conf_file)
  @current_resource.value(get_conf_value(@current_resource.name))
end

action :put do
  if @current_resource.value == @new_resource.value
    Chef::Log.info("#{@new_resource} already up to date")
  else
    command_args = [base_cmd, 'put', @new_resource.name, @new_resource.value].join(' ')
    command = Mixlib::ShellOut.new(command_args)
    command.run_command
    @new_resource.updated_by_last_action(true)
  end
end

def base_cmd
  "#{@new_resource.conftool} -f #{@new_resource.conf_file}"
end

def get_conf_value(key, conf_file = @new_resource.conf_file)
  conf = Gazzang::Ztrustee::Helpers.load_conf(conf_file)
  value = conf.fetch(key, nil)
end

alias_method :action_add, :action_put

