# TODO: add actions for :activate_client, :enable_client, :disable_client, :disable_unactivated, :set_auth
actions :add, :set_authcode

default_action :add

attribute :name, :kind_of => String, :required => true
attribute :contacts, :kind_of => Array, :required => true, :default => nil
attribute :orgtool_path, :kind_of => String, :default => '/usr/lib/ztrustee-server/orgtool'
attribute :authcode, :kind_of => [NilClass, String], :default => nil

