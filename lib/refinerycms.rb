# Load all dependencies generically using the same name as the folder they're in.
# This is the naming convention we'll have to stick to and it also happens
# to be the standard naming convention and assumes each engine has a gemspec.
# lib/refinery.rb is loaded first and this assumes we're in Refinery.root.join('lib')
(Pathname.glob(File.expand_path('../refinery.rb', __FILE__)) |
 Pathname.glob(File.expand_path('../../**/*.gemspec', __FILE__)).map{|gemspec|
  gemspec.parent.join('lib', "#{gemspec.parent.split.last.to_s.downcase}.rb")
}).each do |engine_file|
  require engine_file if engine_file.file?
end
