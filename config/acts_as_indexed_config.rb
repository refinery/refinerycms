# The acts_as_indexed instructions tell us to put this in environment/initializers/
# but that doesn't work so we're putting it here and requiring it using refinery.
ActsAsIndexed::Configuration.module_eval do
  def initialize
    @index_file = Rails.root.join('tmp', 'index') if Rails.root
    @index_file_depth = 3
    @min_word_size = 3
    @if_proc = if_proc
  end
end
