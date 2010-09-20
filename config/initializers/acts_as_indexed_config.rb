ActsAsIndexed.configure do |config|
  config.index_file = Rails.root.join('tmp', 'index')
  config.index_file_depth = 3
  config.min_word_size = 3
end
