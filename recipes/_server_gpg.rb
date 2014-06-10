gpg_bin = '/usr/bin/gpg'
conftool = '/usr/lib/ztrustee-server/conftool'

bash 'generate and upload ztrustee-server key pair' do
  code <<-EOH
qualified_fp=$(/usr/lib/ztrustee/genkey #{node[:ztrustee][:server_conf_dir]} #{node[:ztrustee][:server_email]} server)
fingerprint=$(echo "$qualified_fp" | sed 's/.*\\///')
#{gpg_bin} --batch --yes --homedir #{node[:ztrustee][:server_conf_dir]} -vvv --keyserver hkp://localhost:80 --send-keys 0x$fingerprint
#{conftool} -f #{node[:ztrustee][:server_conf_dir]}/ztrustee.conf put LOCAL_FINGERPRINT "$qualified_fp"
EOH
  user node[:ztrustee][:server_user]
  only_if {
    conf = Gazzang::Ztrustee::Helpers.load_conf
    conf['LOCAL_FINGERPRINT'].nil? || conf['LOCAL_FINGERPRINT'].empty?
  }
  notifies :run, 'execute[init license authority keyring]', :immediately
end

execute 'init license authority keyring' do
  command '/usr/lib/ztrustee-server/orgtool init'
  user node[:ztrustee][:server_user]
  action :nothing
end
