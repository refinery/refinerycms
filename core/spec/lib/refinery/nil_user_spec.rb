require 'spec_helper_no_rails'
require 'refinery/nil_user'

module Refinery
  module Core
    RSpec.describe NilUser do
      describe "plugins" do
        it "has all" do
          expect(subject.plugins).to eq(Refinery::Plugins.registered)
        end
      end

      describe "landing url" do
        let(:plugins) { double("plugins") }

        before do
          allow(subject).to receive(:plugins).and_return(plugins)
        end

        it "queries for the first landable url" do
          expect(plugins).to receive(:first_url_in_menu)
          subject.landing_url
        end
      end
    end
  end
end
