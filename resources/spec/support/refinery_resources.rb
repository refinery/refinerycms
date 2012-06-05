require 'refinerycms-testing'

RSpec.configure do |config|
  # So that resource factories don't fail to create
  config.before do
    Refinery::Resources.configure do |resources|
      resources.max_file_size = 52428800
    end
  end
end
