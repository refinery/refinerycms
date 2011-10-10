require 'spec_helper'

describe ::Refinery::<%= class_name %> do

  def reset_<%= singular_name %>(options = {})
    @valid_attributes = {
      :id => 1<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? -%>,
      :<%= title.name %> => "RSpec is great for testing too"<% end %>
    }

    @<%= singular_name %>.destroy! if @<%= singular_name %>
    @<%= singular_name %> = <%= class_name %>.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_<%= singular_name %>
  end

  context "validations" do
    <% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? %>
    it "rejects empty <%= title.name %>" do
      <%= class_name %>.new(@valid_attributes.merge(:<%= title.name %> => "")).should_not be_valid
    end

    it "rejects duplicate <%= title.name %>" do
      # as one gets created before each spec by reset_<%= singular_name %>
      <%= class_name %>.new(@valid_attributes).should_not be_valid
    end
    <% end %>
  end

end
