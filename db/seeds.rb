# Create a default themes directory.
Rails.root.join("themes").mkdir unless Rails.root.join("themes").directory?

# Refinery settings
Dir[Rails.root.join('db', 'seeds','*.rb')].each do |file|
  require file
end
