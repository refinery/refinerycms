require 'routing.rb'
I18n.load_path << Dir[File.expand_path(File.dirname(__FILE__) + File.join(%w(/.. config locales *.yml)))]