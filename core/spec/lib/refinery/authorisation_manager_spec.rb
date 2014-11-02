require 'spec_helper_no_rails'
require 'refinery/authorisation_manager'

module Refinery
  module Core
    RSpec.describe AuthorisationManager do
      subject { Refinery::Core::AuthorisationManager.instance }

      it "returns a Refinery nil user from its user factory" do
        expect(subject.send(:user_factory).call).to be_an_instance_of Refinery::Core::NilUser
      end
    end
  end
end
