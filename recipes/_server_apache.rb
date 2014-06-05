%w{ default mod_ssl mod_rewrite mod_wsgi mod_proxy_http }.each do |r|
  include_recipe "apache2::#{r}"
end

template "#{node[:apache][:dir]}/sites-available/ztrustee.conf" do
  source 'apache-ztrustee.conf.erb'
  owner node[:apache][:user]
  group node[:apache][:group]
  mode 0640
end

template "#{node[:apache][:dir]}/sites-available/ztrusteehkp.conf" do
  source 'apache-ztrusteehkp.conf.erb'
  owner node[:apache][:user]
  group node[:apache][:group]
  mode 0640
end

%w( ztrustee ztrusteehkp ).each do |zsite|
  file "/etc/httpd/conf.d/#{zsite}" do
    action :delete
  end

  apache_site zsite do
    action :enable
  end
end
