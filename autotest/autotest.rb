###  uncomment any of the following requires applicable for your system
###  and then copy this to .autotest if you are using the ZenTest autotest.
# require "autotest/restart"
# require "test_notifier/runner/autotest"
# require "redgreen/autotest"
# require "autotest/timestamp"

# adds exceptions from .gitignore file, please modify exceptions there!
imported_exceptions =  IO.readlines('.gitignore').inject([]) do |acc, line|
  acc << line.strip if line.to_s[0] != '#' && line.strip != ''; acc
end

Autotest.add_hook :initialize do |autotest|
  imported_exceptions.each do |exception|
    autotest.add_exception(exception)
  end
end
