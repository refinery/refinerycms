require "spec_helper"

module Refinery
  module <%= namespacing %>
    describe <%= class_name.pluralize %>Controller, type: :controller do

      before do
        @route = Refinery::<%= namespacing %>::Engine.routes
        Refinery::<%= namespacing %>::Engine::load_seed

        @new_page = Refinery::Page.new
        allow(Refinery::Page).to receive_messages(:where => [ @new_page ])
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

        before{
          allow_any_instance_of(<%= class_name %>).to receive(:save).and_return( true )
        }
<% @creationParams =  singular_name + ": {" +
attributes.map { |attribute|
case attribute.type
  when :image, :resource, :integer
    attribute.name + ": " + "1"
  when :string, :radio, :select, :dropdown, :text
    attribute.name + ": " + '"foo"'
  when :boolean, :checkbox
    attribute.name + ": " + "false"
  end
}.join(", ") + "}"
%>
        it "before_filter assigns page to <%= plural_name %>/new" do
          post :create, <%= @creationParams %>
          expect(assigns(:page)).to eq @new_page
        end

        it "before_filter assigns a new <%= singular_name %>" do
          post :create, <%= @creationParams %>
          expect(assigns(:<%= singular_name %>)).to be_a_new(<%= class_name %>)
        end

        it "redirects to thank_you" do
          post :create, <%= @creationParams %>
          expect(response).to redirect_to "/<%= plural_name %>/thank_you"
        end

        describe "when it can't save the <%= singular_name %>" do

          before {
          allow_any_instance_of(<%= class_name %>).to receive(:save).and_return( false )
          }

          it "redirects to new if it can't save" do
            post :create, <%= @creationParams %>

            expect(response).to render_template(:new)
          end
        end

      end
    end
  end
end
