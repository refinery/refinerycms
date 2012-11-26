module Refinery
  module Testing
    module ControllerMacros
      module Authentication
        def self.extended(base)
          base.send :include, Devise::TestHelpers
        end

        def refinery_login_with(*roles)
          mock_user roles
        end

        def refinery_login_with_factory(factory)
          factory_user factory
        end

        def mock_user(roles)
          let(:controller_permission) { true }
          roles = handle_deprecated_roles! roles
          let(:logged_in_user) do
            user = mock 'Refinery::User', :username => 'Joe Fake'

            roles.each do |role|
              user.should_receive(:has_role?).
                   any_number_of_times.with(role).and_return true
            end
            if roles.exclude? :superuser
              user.should_receive(:has_role?).
                   any_number_of_times.with(:superuser).and_return false
            end

            user
          end

          before do
            controller.should_receive(:refinery_user_required?).and_return false
            controller.should_receive(:authenticate_refinery_user!).and_return true
            controller.should_receive(:restrict_plugins).and_return true
            controller.should_receive(:allow_controller?).and_return controller_permission
            controller.stub(:refinery_user?).and_return true
            controller.stub(:current_refinery_user).and_return logged_in_user
          end
        end

        def factory_user(factory)
          let(:logged_in_user) { FactoryGirl.create factory }
          before do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in logged_in_user
          end
        end

        def login_user
          Refinery.deprecate :login_user, :when => '2.2', :replacement => 'refinery_login_with :user'
          refinery_login_with :user
        end

        def login_refinery_user
          Refinery.deprecate :login_refinery_user, :when => '2.2', :replacement => 'refinery_login_with :refinery_user'
          refinery_login_with :refinery_user
        end

        def login_refinery_superuser
          Refinery.deprecate :login_refinery_superuser, :when => '2.2', :replacement => 'refinery_login_with :refinery_superuser'
          refinery_login_with :refinery_superuser
        end

        def login_refinery_translator
          Refinery.deprecate :login_refinery_translator, :when => '2.2', :replacement => 'refinery_login_with :refinery_translator'
          refinery_login_with :refinery_translator
        end

        private
        def handle_deprecated_roles!(*roles)
          mappings = {
            :user => [],
            :refinery_user => [:refinery],
            :refinery_superuser => [:refinery, :superuser],
            :refinery_translator => [:refinery, :translator]
          }
          mappings[roles.first] || roles
        end
      end
    end
  end
end
