module Refinery
  module Testing
    module RequestMacros
      module Authentication
        def login_with(factory)
          let!(:logged_in_user) { Factory.create(factory) }

          before do
            login_as logged_in_user, :scope => :refinery_user
          end
        end

        def login_refinery_user
          login_with(:refinery_user)
        end

        def login_refinery_superuser
          login_with(:refinery_superuser)
        end

        def login_refinery_translator
          login_with(:refinery_translator)
        end
      end
    end
  end
end
