# Create a default themes directory.
Rails.root.join("themes").mkpath if Rails.root.writable?

# Refinery settings
Dir[Rails.root.join('db', 'seeds','*.rb').to_s].each do |file|
  load(file)
end
