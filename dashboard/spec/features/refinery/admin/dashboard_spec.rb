require "spec_helper"

describe "dashboard", :type => :feature do
  refinery_login_with :refinery_user

  describe "quick tasks" do
    specify "buttons" do
      visit refinery.admin_dashboard_path

      expect(page).to have_content(::I18n.t('quick_tasks', :scope => 'refinery.admin.dashboard.index'))

      # add new page
      expect(page).to have_content(::I18n.t('add_a_new_page', :scope => 'refinery.admin.dashboard.actions'))
      expect(page).to have_selector("a[href='#{refinery.new_admin_page_path}']")

      # update page
      expect(page).to have_content(::I18n.t('update_a_page', :scope => 'refinery.admin.dashboard.actions'))
      expect(page).to have_selector("a[href='#{refinery.admin_pages_path}']")

      # upload file
      if defined? Refinery::Resource
        expect(page).to have_content(::I18n.t('upload_a_file', :scope => 'refinery.admin.dashboard.actions'))
        expect(page).to have_selector("a[href*='#{refinery.new_admin_resource_path}']")
      end

      # upload image
      if defined? Refinery::Image
        expect(page).to have_content(::I18n.t('upload_a_image', :scope => 'refinery.admin.dashboard.actions'))
        expect(page).to have_selector("a[href*='#{refinery.new_admin_image_path}']")
      end
    end
  end
end
