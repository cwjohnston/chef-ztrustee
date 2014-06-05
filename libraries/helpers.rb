module Gazzang
  module Ztrustee
    module Helpers
      class << self

        def load_conf(conf_file='/var/lib/ztrustee/.ztrustee/ztrustee.conf')
          JSON.load(File.read(conf_file))
        end

      end
    end
  end
end
