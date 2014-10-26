module Refinery
  module Testing
    module FeatureMacros
      module Authentication

        def refinery_login
          # NO-OP, Overwrite this in an extension.
        end

        def refinery_login_with(factory)
          Refinery.deprecate('refinery_login_with', when: '3.1', replacement: 'refinery_login')
        end

      end
    end
  end
end
