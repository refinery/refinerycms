require "spec_helper"

describe Refinery do
  describe "Admin" do
    describe "<%= plural_name %>" do
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

      describe "create" do
        before(:each) do
          visit refinery_admin_<%= plural_name %>_path

          click_link "Add New <%= singular_name.titleize %>"
        end

        context "valid data" do
          it "should succeed" do
            fill_in "<%= title.name.titleize %>", :with => "This is a test of the first string field"
            click_button "Save"

            page.should have_content("'This is a test of the first string field' was successfully added.")
            Refinery::<%= class_name.pluralize %>::<%= class_name %>.count.should == 1
          end
        end

        context "invalid data" do
          it "should fail" do
            click_button "Save"

            page.should have_content("<%= title.name.titleize %> can't be blank")
            Refinery::<%= class_name.pluralize %>::<%= class_name %>.count.should == 0
          end
        end

        context "duplicate" do
          before(:each) { FactoryGirl.create(:<%= singular_name %>, :<%= title.name %> => "UniqueTitle") }

          it "should fail" do
            visit refinery_admin_<%= plural_name %>_path

            click_link "Add New <%= singular_name.titleize %>"

            fill_in "<%= title.name.titleize %>", :with => "UniqueTitle"
            click_button "Save"

            page.should have_content("There were problems")
            Refinery::<%= class_name.pluralize %>::<%= class_name %>.count.should == 1
          end
        end
      end

      describe "edit" do
        before(:each) { FactoryGirl.create(:<%= singular_name %>, :<%= title.name %> => "A <%= title.name %>") }

        it "should succeed" do
          visit refinery_admin_<%= plural_name %>_path

          within ".actions" do
            click_link "Edit this <%= singular_name.titleize.downcase %>"
          end

          fill_in "<%= title.name.titleize %>", :with => "A different <%= title.name %>"
          click_button "Save"

          page.should have_content("'A different <%= title.name %>' was successfully updated.")
          page.should have_no_content("A <%= title.name %>")
        end
      end

      describe "destroy" do
        before(:each) { FactoryGirl.create(:<%= singular_name %>, :<%= title.name %> => "UniqueTitleOne") }

        it "should succeed" do
          visit refinery_admin_<%= plural_name %>_path

          click_link "Remove this <%= singular_name.titleize.downcase %> forever"

          page.should have_content("'UniqueTitleOne' was successfully removed.")
          Refinery::<%= class_name.pluralize %>::<%= class_name %>.count.should == 0
        end
      end
<% end %>
    end
  end
end
