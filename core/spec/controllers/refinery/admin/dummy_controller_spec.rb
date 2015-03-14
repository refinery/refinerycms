require "spec_helper"

module Refinery
  module Admin
    class Engine < ::Rails::Engine
      isolate_namespace Refinery::Admin
    end

    Engine.routes.draw do
      resources :dummy
    end

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
      routes { Refinery::Admin::Engine.routes }

      context "as refinery user" do
        refinery_login_with :refinery

        context "with permission" do
          it "allows access" do
            allow(controller).to receive(:allow_controller?).and_return(true)
            expect(controller).not_to receive :error_404
            get :index
          end
        end

        context "without permission" do
          it "denies access" do
            allow(controller).to receive(:allow_controller?).and_return(false)
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
