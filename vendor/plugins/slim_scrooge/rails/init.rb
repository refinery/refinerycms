unless File.exists?(File.join(File.dirname(__FILE__), "../", "ext", "Makefile"))
  Dir.chdir(File.join(File.dirname(__FILE__), "../", "ext"))
  `rake`
end

require 'slim_scrooge.rb'