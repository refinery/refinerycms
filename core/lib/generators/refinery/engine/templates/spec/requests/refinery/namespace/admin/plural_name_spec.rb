# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "<%= namespacing %>" do
    describe "Admin" do
      describe "<%= plural_name %>" do
        refinery_login_with :refinery_user
<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? %>
        describe "<%= plural_name %> list" do
          before(:each) do
            FactoryGirl.create(:<%= singular_name %>, :<%= title.name %> => "UniqueTitleOne")
            FactoryGirl.create(:<%= singular_name %>, :<%= title.name %> => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.<%= namespacing.underscore %>_admin_<%= plural_name %>_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before(:each) do
            visit refinery.<%= namespacing.underscore %>_admin_<%= plural_name %>_path

            click_link "Add New <%= singular_name.titleize %>"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "<%= title.name.titleize %>", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::<%= namespacing %>::<%= class_name %>.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("<%= title.name.titleize %> can't be blank")
              Refinery::<%= namespacing %>::<%= class_name %>.count.should == 0
            end
          end

          context "duplicate" do
            before(:each) { FactoryGirl.create(:<%= singular_name %>, :<%= title.name %> => "UniqueTitle") }

            it "should fail" do
              visit refinery.<%= namespacing.underscore %>_admin_<%= plural_name %>_path

              click_link "Add New <%= singular_name.titleize %>"

              fill_in "<%= title.name.titleize %>", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::<%= namespacing %>::<%= class_name %>.count.should == 1
            end
          end
<% if localized? %>
          context "with translations" do
            before(:each) do
              Refinery::I18n.stub(:frontend_locales).and_return([:en, :cs])
            end

            describe "add a page with title for default locale" do
              before do
                visit refinery.<%= namespacing.underscore %>_admin_<%= plural_name %>_path
                click_link "Add New <%= singular_name.titleize %>"
                fill_in "<%= title.name.titleize %>", :with => "First column"
                click_button "Save"
              end

              it "should succeed" do
                Refinery::<%= namespacing %>::<%= class_name %>.count.should == 1
              end

              it "should show locale flag for page" do
                p = Refinery::<%= namespacing %>::<%= class_name %>.last
                within "#<%= singular_name %>_#{p.id}" do
                  page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
                end
              end

              it "should show <%= title.name %> in the admin menu" do
                p = Refinery::<%= namespacing %>::<%= class_name %>.last
                within "#<%= singular_name %>_#{p.id}" do
                  page.should have_content('First column')
                end
              end
            end

            describe "add a <%= singular_name %> with title for primary and secondary locale" do
              before do
                visit refinery.<%= namespacing.underscore %>_admin_<%= plural_name %>_path
                click_link "Add New <%= singular_name.titleize %>"
                fill_in "<%= title.name.titleize %>", :with => "First column"
                click_button "Save"

                visit refinery.<%= namespacing.underscore %>_admin_<%= plural_name %>_path
                within ".actions" do
                  click_link "Edit this <%= singular_name %>"
                end
                within "#switch_locale_picker" do
                  click_link "Cs"
                end
                fill_in "<%= title.name.titleize %>", :with => "First translated column"
                click_button "Save"
              end

              it "should succeed" do
                Refinery::<%= namespacing %>::<%= class_name %>.count.should == 1
                Refinery::<%= namespacing %>::<%= class_name %>::Translation.count.should == 2
              end

              it "should show locale flag for page" do
                p = Refinery::<%= namespacing %>::<%= class_name %>.last
                within "#<%= singular_name %>_#{p.id}" do
                  page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
                  page.should have_css("img[src='/assets/refinery/icons/flags/cs.png']")
                end
              end

              it "should show <%= title.name %> in backend locale in the admin menu" do
                p = Refinery::<%= namespacing %>::<%= class_name %>.last
                within "#<%= singular_name %>_#{p.id}" do
                  page.should have_content('First column')
                end
              end
            end

            describe "add a <%= title.name %> with title only for secondary locale" do
              before do
                visit refinery.<%= namespacing.underscore %>_admin_<%= plural_name %>_path
                click_link "Add New <%= singular_name.titleize %>"
                within "#switch_locale_picker" do
                  click_link "Cs"
                end

                fill_in "<%= title.name.titleize %>", :with => "First translated column"
                click_button "Save"
              end

              it "should show title in backend locale in the admin menu" do
                p = Refinery::<%= namespacing %>::<%= class_name %>.last
                within "#<%= singular_name %>_#{p.id}" do
                  page.should have_content('First translated column')
                end
              end

              it "should show locale flag for page" do
                p = Refinery::<%= namespacing %>::<%= class_name %>.last
                within "#<%= singular_name %>_#{p.id}" do
                  page.should have_css("img[src='/assets/refinery/icons/flags/cs.png']")
                end
              end
            end
          end
<% end %>
        end

        describe "edit" do
          before(:each) { FactoryGirl.create(:<%= singular_name %>, :<%= title.name %> => "A <%= title.name %>") }

          it "should succeed" do
            visit refinery.<%= namespacing.underscore %>_admin_<%= plural_name %>_path

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
            visit refinery.<%= namespacing.underscore %>_admin_<%= plural_name %>_path

            click_link "Remove this <%= singular_name.titleize.downcase %> forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::<%= namespacing %>::<%= class_name %>.count.should == 0
          end
        end
<% end %>
      end
    end
  end
end
