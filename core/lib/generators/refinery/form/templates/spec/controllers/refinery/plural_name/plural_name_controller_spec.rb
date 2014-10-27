require "spec_helper"

module Refinery
  module <%= namespacing %>
    describe <%= class_name.pluralize %>Controller do

      routes { Refinery::Core::Engine.routes }

      before(:each) do
        Refinery::<%= namespacing %>::Engine::load_seed

        @new_page = Refinery::Page.new
        Refinery::Page.stub(:find_by_link_url).and_return(@new_page)
      end

      describe "GET new" do
        it "before_filter assigns a new <%= singular_name %>" do
          get :new
          expect(assigns(:<%= singular_name %>)).to be_a_new(<%= class_name %>)
        end
        it "before_filter assigns page to <%= plural_name %>/new" do
          get :new
          expect(assigns(:page)).to eq @new_page
        end
      end

      describe "POST create" do

        before(:each){
          <%= class_name %>.any_instance.stub(:save).and_return( true )
        }

        it "before_filter assigns page to <%= plural_name %>/new" do
          post :create
          expect(assigns(:page)).to eq @new_page
        end

        it "before_filter assigns a new <%= singular_name %>" do
          post :create
          expect(assigns(:<%= singular_name %>)).to be_a_new(<%= class_name %>)
        end

        it "redirects to thank_you" do
          post :create #, <%= singular_name %>: FactoryGirl.attributes_for(:<%= singular_name %>)
          response.should redirect_to "/<%= plural_name %>/thank_you"
        end

        describe "when it can't save the <%= singular_name %>" do

          before(:each) {
            <%= class_name %>.any_instance.stub(:save).and_return( false )
          }

          it "redirects to new if it can't save" do
            post :create #, <%= singular_name %>: @no_save_<%= singular_name %>

            response.should render_template(:new)
          end
        end

      end
    end
  end
end
