ztrustee_org 'test_org' do
  contacts ['test@example.com', 'test2@example.com']
  authcode "changeme"
  action [:add, :set_authcode]
end
