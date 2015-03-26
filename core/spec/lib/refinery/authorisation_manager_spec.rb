require 'spec_helper_no_rails'
require 'refinery/core/authorisation_manager'

module Refinery
  module Core
    RSpec.describe AuthorisationManager do
      subject { Refinery::Core::AuthorisationManager.new }
    end
  end
end
