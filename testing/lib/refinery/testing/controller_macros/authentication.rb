module Refinery
  module Testing
    module ControllerMacros
      module Authentication
        def self.extended(base)
          base.send(:include, Devise::TestHelpers)
        end

        def login_user
          before(:each) do
            @user = FactoryGirl.create(:user)
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in @user
          end
        end

        def login_refinery_user
          before(:each) do
            @refinery_user = FactoryGirl.create(:refinery_user)
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in @refinery_user
          end
        end

        def login_refinery_translator
          before(:each) do
            @refinery_translator = FactoryGirl.create(:refinery_translator)
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            sign_in @refinery_translator
          end
        end
      end
    end
  end
end
