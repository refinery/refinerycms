require "spec_helper"

module Refinery
  module <%= namespacing %>

    describe "<%= namespacing %> request specs", type: :request do

      before(:each) do
        Refinery::<%= namespacing %>::Engine.load_seed
      end

      it "successfully gets the index path as redirection" do
        get("/<%= plural_name %>")
        expect(response).to be_redirect
        expect(response).to redirect_to("/<%= plural_name %>/new")
      end

      it "successfully gets the new path" do
        get("/<%= plural_name %>/new")
        expect(response).to be_success
        expect(response).to render_template(:new)
      end

      it "successfully gets the thank_you path" do
        get("/<%= plural_name %>/thank_you")
        expect(response).to be_success
        expect(response).to render_template(:thank_you)
      end

    end
  end
end
