module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      root_path

    when /the list of pages/
      admin_pages_path

    when /the new page form/
      new_admin_page_path

    when /the list of users/
      admin_users_path

    when /the list of files/
      admin_resources_path

    when /the new file form/
      new_admin_resource_path

    when /the list of images/
      admin_images_path

     when /the new image form/
      new_admin_image_path

    when /the contact page/
      new_inquiry_path

    when /the contact thank you page/
      thank_you_inquiries_path

    when /the contact create page/
      inquiries_path

    when /the list of inquiries/
      admin_inquiries_path

    when /the list of spam inquiries/
      spam_admin_inquiries_path

    when /the (d|D)ashboard/
      admin_dashboard_index_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
