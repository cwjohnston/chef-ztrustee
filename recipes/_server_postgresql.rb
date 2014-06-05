{ 'DB_ENGINE' => 'postgresql',
  'DB_USER' => node[:ztrustee][:database][:user],
  'DB_PASSWORD' => node[:ztrustee][:database][:password],
  'DB_HOST' => node[:ztrustee][:database][:host],
  'DB_PORT' => node[:postgresql][:config][:port],
  'DB_DATABASE' => 'ztrustee' }.each do |z_key, z_value|
  ztrustee_conf z_key do
    value z_value
  end
end

current_hba = node[:postgresql][:pg_hba].to_a
ztrustee_hba = []
%w( 127.0.0.1/32 ::1/128 ).each do |localhost|
   new_entry = {
    'method' => 'md5',
    'addr' => localhost,
    'user' => node[:ztrustee][:database][:user],
    'db' => node[:ztrustee][:database][:db_name],
    'type' => 'host'
  }
  unless current_hba.any? {|entry| entry == new_entry}
    ztrustee_hba << new_entry
  end
end

node.set[:postgresql][:pg_hba] = current_hba.concat(ztrustee_hba)

include_recipe 'postgresql::server'
include_recipe 'postgresql::ruby'

postgresql_connection_info = {
  :host     => node[:ztrustee][:database][:host],
  :port     => node[:postgresql][:config][:port],
  :username => 'postgres',
  :password => node[:postgresql][:password][:postgres]
}

postgresql_database node[:ztrustee][:database][:db_name] do
  connection postgresql_connection_info
  action :create
end

postgresql_database_user node[:ztrustee][:database][:user] do
  connection postgresql_connection_info
  password node[:ztrustee][:database][:password]
  database_name node[:ztrustee][:database][:db_name]
  privileges [:all]
  action [:create, :grant]
end

execute 'dbatool migrate' do
  command "/usr/lib/ztrustee-server/dbatool --confdir #{node[:ztrustee][:server_conf_dir]} --production migrate -u"
  user node[:ztrustee][:server_user]
  action :nothing
  subscribes :run, "postgresql_database_user[ztrustee]", :immediately
  notifies :run, 'execute[dbatool create]', :immediately
end

execute 'dbatool create' do
  command "/usr/lib/ztrustee-server/dbatool --confdir #{node[:ztrustee][:server_conf_dir]} --production create"
  user node[:ztrustee][:server_user]
  action :nothing
end
