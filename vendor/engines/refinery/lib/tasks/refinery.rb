# Because we use plugins that are shipped via gems, we lose their rake tasks.
# So here, we find them (if there are any) and include them into rake.
extra_rake_tasks = []
if defined?(Refinery) && Refinery.is_a_gem
  extra_rake_tasks << Dir[Refinery.root.join("vendor", "plugins", "*", "**", "tasks", "**", "*", "*.rake").to_s].sort
end

# We also need to load in the rake tasks from gem plugins whether Refinery is a gem or not:
if $refinery_gem_plugin_lib_paths.present?
  paths = $refinery_gem_plugin_lib_paths.reject do |path|
    path =~ /^#{Rails.root.join('vendor', 'plugins')}/
  end

  extra_rake_tasks << paths.collect {|path| Dir[File.join(%W(#{path} tasks ** *.rake))].sort}
end

# Load in any extra tasks that we've found.
extra_rake_tasks.flatten.reject{|t| t.nil? or t =~ /rspec/ }.uniq.each {|rake| load rake }
