module Refinery
  module Testing
    module RequestMacros
      module Authentication
        def refinery_login_with(factory)
          let!(:logged_in_user) { create(factory) }

          before do
            login_as logged_in_user, :scope => :refinery_user
          end
        end

        def login_refinery_user
          Refinery.deprecate(:login_refinery_user, :when => '2.2', :replacement => 'refinery_login_with :refinery_user')
          refinery_login_with(:refinery_user)
        end

        def login_refinery_superuser
          Refinery.deprecate(:login_refinery_superuser, :when => '2.2', :replacement => 'refinery_login_with :refinery_superuser')
          refinery_login_with(:refinery_superuser)
        end

        def login_refinery_translator
          Refinery.deprecate(:login_refinery_translator, :when => '2.2', :replacement => 'refinery_login_with :refinery_translator')
          refinery_login_with(:refinery_translator)
        end
      end
    end
  end
end
