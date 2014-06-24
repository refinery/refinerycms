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
    describe DummyController, :type => :controller do
      context "as refinery user" do
        refinery_login_with :refinery

        context "with permission" do
          let(:controller_permission) { true }
          it "allows access" do
            expect(controller).not_to receive :error_404
            get :index
          end
        end

        context "without permission" do
          let(:controller_permission) { false }
          it "denies access" do
            expect(controller).to receive :error_404
            get :index
          end
        end

        describe "force_ssl!" do
          before do
            allow(controller).to receive(:require_refinery_users!).and_return(false)
          end

          it "is false so standard HTTP is used" do
            allow(Refinery::Core).to receive(:force_ssl).and_return(false)
            expect(controller).not_to receive(:redirect_to).with(:protocol => 'https')

            get :index
          end

          it "is true so HTTPS is used" do
            allow(Refinery::Core).to receive(:force_ssl).and_return(true)
            expect(controller).to receive(:redirect_to).with(:protocol => 'https')

            get :index
          end
        end
      end
    end
  end
end
