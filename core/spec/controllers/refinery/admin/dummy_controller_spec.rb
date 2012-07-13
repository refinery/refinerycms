require "spec_helper"

module Refinery
  module Admin
    class DummyController < Refinery::AdminController
      def index
        render :nothing => true
      end
    end
  end
end

module Refinery
  module Admin
    describe DummyController do
      context "as refinery user" do
        refinery_login_with :refinery

        context "with permission" do
          let(:controller_permission) { true }
          it "allows access" do
            controller.should_not_receive :error_404
            get :index
          end
        end

        context "without permission" do
          let(:controller_permission) { false }
          it "denies access" do
            controller.should_receive :error_404
            get :index
          end
        end
      end
    end
  end
end