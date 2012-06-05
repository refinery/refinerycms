require 'refinerycms-testing'

RSpec.configure do |config|
  # So that image factories don't fail to create
  config.before do
    Refinery::Images.configure do |images|
      images.max_file_size = 52428800
    end
  end
end
