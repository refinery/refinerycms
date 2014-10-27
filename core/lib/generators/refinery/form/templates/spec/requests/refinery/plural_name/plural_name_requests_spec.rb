require "spec_helper"

module Refinery
  module <%= namespacing %>
    describe "<%= plural_name %> request specs" do

      # routes { Refinery::Core::Engine.routes }

      it "redirects the index path to new" do
subject { get "/<%= plural_name %>" }

        expect(response).to redirect_to(:wq
                                        "/<%= plural_name %>/new")

      end

    end
  end
end
