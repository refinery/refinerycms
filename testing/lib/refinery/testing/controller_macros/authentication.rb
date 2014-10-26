module Refinery
  module Testing
    module ControllerMacros
      module Authentication

        def refinery_login_with(*roles)
          Refinery.deprecate('refinery_login_with', when: '3.1', replacement: 'refinery_login')
          refinery_login
        end

        def refinery_login_with_factory(factory)
          Refinery.deprecate('refinery_login_with_factory', when: '3.1', replacement: 'refinery_login')
          refinery_login
        end

        def refinery_login
          # NO-OP for now.
        end
      end
    end
  end
end
