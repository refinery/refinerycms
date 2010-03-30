require 'routing.rb'
# load yml routes from this plugin itself (lowest priority defaults)
(i18n_plugin_ymls = Dir[File.expand_path(File.dirname(__FILE__) + File.join(%w(/.. config locales *.yml)))]).each do |yml|
  I18n.load_path.unshift(yml)
end

# now load yml from the refinery plugin's locales
Dir[Refinery.root.join("vendor", "plugins", "*", "config", "locales", "*.yml").to_s].reject{|d| i18n_plugin_ymls.include?(d)}.each do |yml|
  I18n.load_path.unshift(yml)
end

# now load yml from plugins inside the app (unless the app is refinery (not a gem))
if Refinery.is_a_gem
  Dir[Rails.root.join("vendor", "plugins", "*", "config", "locals", "*.yml").to_s].each do |yml|
    I18n.load_path.unshift(yml)
  end
end

# now load yml from the app itself
Dir[Rails.root.join("config", "locales", "*.yml").to_s].each do |yml|
  I18n.load_path.unshift(yml)
end

# set up a default locale, if the database exists.
if RefinerySetting.table_exists?
  I18n.locale = RefinerySetting.find_or_set(:refinery_i18n_locale, RoutingFilter::Locale.locales.first)
end