require 'refinery'

# Load all dependencies generically using the same name as the folder they're in.
# This is the naming convention we'll have to stick to and it also happens
# to be the standard naming convention.
Dir[File.expand_path("../**", __FILE__).to_s].each do |dir|
  if (dir = Pathname.new(dir)).directory?
    if (require_file = dir.join('lib', "#{dir.split.last}.rb")).file?
      require require_file
    end
  end
end
