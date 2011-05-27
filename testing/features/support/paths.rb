([Rails.root] | ::Refinery::Plugins.registered.pathnames).map{|path|
  path.join('features', 'support', 'paths.rb')
}.reject{|p| !p.exist?}.each do |paths|
  require paths
end

module NavigationHelpers
  # Loads in path_to functions from the engines that Refinery is using.
  # They should look like this:
  # module NavigationHelpers
  #   module Refinery
  #     module EngineName
  #       def path_to(page_name)
  #         case page_name
  #         when /regexp/
  #           some_path
  #         else
  #           nil
  #         end
  #       end
  #     end
  #   end
  # end

  NavigationHelpers::Refinery.constants.each do |name|
    begin
      if (mod = "NavigationHelpers::Refinery::#{name}".constantize)
        mod.module_eval %{alias :#{name.downcase}_path_to :path_to}
        include mod
      end
    rescue
      $stdout.puts $!.message
    end
  end if defined?(NavigationHelpers::Refinery)
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the admin root/
      admin_root_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_username($1))

    else
      # Loads in path_to functions from the engines that Refinery is using.
      # They should look like this:
      # module NavigationHelpers
      #   module Refinery
      #     module EngineName
      #       def path_to(page_name)
      #         case page_name
      #         when /regexp/
      #           some_path
      #         else
      #           nil
      #         end
      #       end
      #     end
      #   end
      # end
      NavigationHelpers::Refinery.constants.each do |name|
        begin
          if (path = self.send(:"#{name.downcase}_path_to", page_name)).present?
            return path
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
          "Now, go and add a mapping in #{Rails.root.join('features', 'support', 'paths.rb')}"
      end
    end
  end
end

World(NavigationHelpers)
