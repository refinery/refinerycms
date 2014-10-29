module Refinery
  module Testing
    module ControllerMacros
      module Authentication
        def self.extended(base)
          base.send :include, Devise::TestHelpers
        end

        def refinery_login_with(*roles)
          roles = handle_deprecated_roles!(roles).flatten
          let(:logged_in_user) do
            user = FactoryGirl.create :user
            roles.each do |role|
              user.add_role(role)
            end
            user
          end
          before do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in logged_in_user
          end
        end

        def refinery_login_with_factory(factory)
          factory_user factory
        end

        def factory_user(factory)
          let(:logged_in_user) { FactoryGirl.create factory }
          before do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in logged_in_user
          end
        end

        private
        def handle_deprecated_roles!(*roles)
          mappings = {
            :user => [],
            :refinery_user => [:refinery],
            :refinery_superuser => [:refinery, :superuser]
          }
          mappings[roles.first] || roles
        end
      end
    end
  end
end
