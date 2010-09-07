Dir[File.expand_path('../../../vendor/**/features/support/paths.rb', __FILE__)].flatten.each do |paths|
  require paths
end

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

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

    when /the admin root/
      admin_root_path

    when /the (d|D)ashboard/
      admin_dashboard_path

    when /the login page/
      new_session_path

    when /the forgot password page/
      forgot_users_path

    when /the reset password page/
      reset_users_path(:reset_code => @user.perishable_token)

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      NavigationHelpers::Refinery.constants.each do |possible_pathable|
        begin
          if (mod = "NavigationHelpers::Refinery::#{possible_pathable}".constantize).methods.map(&:to_sym).include?(:path_to)
            if (possible_return = mod.path_to(page_name)).present?
              return self.send(possible_return)
            end
          end
        rescue
          $stdout.puts $!.message
        end
      end if defined?(NavigationHelpers::Refinery)

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
