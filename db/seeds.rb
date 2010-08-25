# Refinery settings
Dir[Rails.root.join('db', 'seeds','*.rb').to_s].each do |file|
  load(file)
end
