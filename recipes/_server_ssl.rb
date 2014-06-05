directory ::File.dirname(node[:ztrustee][:ssl][:cert]) do
  mode 0700
  owner node[:ztrustee][:server_user]
  group node[:ztrustee][:server_group]
  recursive true
end

ssl = node[:ztrustee][:ssl]
ssl_subj = "/C=#{ssl[:country]}/ST=#{ssl[:state]}/L=#{ssl[:locality]}/CN=#{ssl[:common_name]}/emailAddress=#{node[:ztrustee][:server_email]}"

execute 'generate ztrustee-server ssl cert' do
  command "openssl req -new -newkey rsa:#{ssl[:rsa_keysize]} -nodes -x509 -out #{ssl[:cert]} -keyout #{ssl[:key]} -days 3650 -subj #{ssl_subj}"
  not_if { ::File.exists?(ssl[:cert]) }
end

execute 'generate ztrustee-server ca cert' do
  command "certtool -8 --generate-certificate --generate-self-signed --load-privkey #{ssl[:key]} --outfile #{ssl[:ca]} --template #{node[:ztrustee][:conf_dir]}/certtool.cfg"
  not_if { ::File.exists?(ssl[:ca]) }
end

%w( ca key ).each do |f|
  file ssl[f] do
    mode 0400
  end
end

file ssl[:pub_cert] do
  content lazy { ::File.read(ssl[:cert]) }
  mode 0644
end

