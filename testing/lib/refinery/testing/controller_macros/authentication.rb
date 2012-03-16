module Refinery
  module Testing
    module ControllerMacros
      module Authentication
        def self.extended(base)
          base.send(:include, Devise::TestHelpers)
        end

        def refinery_login_with(factory)
          let(:logged_in_user) { FactoryGirl.create factory }
          before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in logged_in_user
          end
        end

        def login_user
          Refinery.deprecate(:login_user, :when => '2.2', :replacement => 'refinery_login_with :user')
          refinery_login_with :user
        end

        def login_refinery_user
          Refinery.deprecate(:login_refinery_user, :when => '2.2', :replacement => 'refinery_login_with :refinery_user')
          refinery_login_with :refinery_user
        end

        def login_refinery_superuser
          Refinery.deprecate(:login_refinery_superuser, :when => '2.2', :replacement => 'refinery_login_with :refinery_superuser')
          refinery_login_with :refinery_superuser
        end

        def login_refinery_translator
          Refinery.deprecate(:login_refinery_translator, :when => '2.2', :replacement => 'refinery_login_with :refinery_translator')
          refinery_login_with :refinery_translator
        end
      end
    end
  end
end
