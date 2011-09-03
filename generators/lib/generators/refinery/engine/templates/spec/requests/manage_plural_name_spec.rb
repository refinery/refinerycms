require "spec_helper"

describe "manage <%= plural_name %>" do
  login_refinery_user
<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? %>
  describe "<%= plural_name %> list" do
    before(:each) do
      FactoryGirl.create(:<%= singular_name %>, :<%= title.name %> => "UniqueTitleOne")
      FactoryGirl.create(:<%= singular_name %>, :<%= title.name %> => "UniqueTitleTwo")
    end

    it "shows two items" do
      visit refinery_admin_<%= plural_name %>_path
      page.should have_content("UniqueTitleOne")
      page.should have_content("UniqueTitleTwo")
    end
  end
<% end %>
end
