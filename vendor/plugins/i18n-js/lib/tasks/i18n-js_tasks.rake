namespace :i18n do
  desc "Copy i18n.js and export the messages files"
  task :setup => :require_lib do
    SimplesIdeias::I18n.setup!
  end

  desc "Export the messages files"
  task :export => :environment do
    SimplesIdeias::I18n.export!
  end

  task :require_lib do
    require File.dirname(__FILE__) + "/../i18n-js"
  end
end
