actions :put

default_action :put

attribute :name,      :kind_of => String, :required => true
attribute :value
attribute :conftool,  :kind_of => String, :default => '/usr/lib/ztrustee-server/conftool'
attribute :conf_file, :kind_of => String, :default => '/var/lib/ztrustee/.ztrustee/ztrustee.conf'


