module Refinery
  module Testing
    module ControllerMacros
      module Authentication

        def refinery_login
          let(:logged_in_user) { Refinery::Core::NilUser.new }
        end

      end
    end
  end
end
