# Create a default themes directory.
Rails.root.join("themes").mkdir unless Rails.root.join("themes").directory?

# Refinery settings
require 'refinery_settings'
require 'inquiry_settings'
require 'pages'