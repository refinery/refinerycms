unless /mswin/ =~ RUBY_PLATFORM || RUBY_VERSION >= "1.9" || defined?(RUBY_ENGINE) && RUBY_ENGINE != "ruby"
  unless File.exists?(File.join(File.dirname(__FILE__), "..", "ext", "Makefile"))
    Dir.chdir(File.join(File.dirname(__FILE__), "..", "ext"))
    `rake`
  end
end

require 'slim_scrooge.rb'
