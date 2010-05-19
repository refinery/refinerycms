# Create a default themes directory.
Rails.root.join("themes").mkdir unless Rails.root.join("themes").directory?
# Refinery settings
puts File.join File.dirname(__FILE__), 'locales'