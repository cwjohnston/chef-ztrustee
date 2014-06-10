node.set[:apache][:default_site_enabled] = false

%w{ default mod_ssl mod_rewrite mod_wsgi mod_proxy_http }.each do |r|
  include_recipe "apache2::#{r}"
end

%w( ztrustee.conf ztrusteehkp.conf ).each do |zsite|
  template "#{node[:apache][:dir]}/sites-available/#{zsite}" do
    source "apache-#{zsite}.erb"
    owner node[:apache][:user]
    group node[:apache][:group]
    mode 0640
  end

  # delete default site configs dropped off by package
  file "/etc/httpd/conf.d/#{zsite}" do
    action :delete
  end

  # enable ztrustee site configs dropped off by this recipe
  apache_site zsite do
    action :enable
  end
end
