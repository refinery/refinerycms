# The acts_as_indexed instructions tell us to put this in environment/initializers/
# but that doesn't work so we're putting it here and requiring it using refinery.
ActsAsIndexed.configure do |config|
  config.index_file = Rails.root.join('tmp', 'index')
  config.index_file_depth = 3
  config.min_word_size = 3
end
