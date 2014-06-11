ztrustee_org 'test_org' do
  contacts ['test@example.com', 'test2@example.com']
  authcode "changeme"
  action [:add, :set_authcode]
end

execute 'register ztrustee client with test_org' do
  command 'ztrustee register -y --insecure --server localhost --org test_org --auth changeme'
  not_if { ::File.exists?('/root/.ztrustee/ztrustee.conf') }
end
