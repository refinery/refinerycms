# Create a default themes directory.
Rails.root.join("themes").mkdir unless Rails.root.join("themes").directory? or !Rails.root.writable?

# Refinery settings
Dir[Rails.root.join('db', 'seeds','*.rb').to_s].each do |file|
  load(file)
end
