time = Time.now
require 'refinerycms-base'
last_time = Time.now
$stdout.puts "It took #{Time.now - time} seconds to load refinerycms-base"
require 'refinerycms-core'
$stdout.puts "It took #{Time.now - last_time} seconds to load refinerycms-core"
last_time = Time.now

require 'refinerycms-authentication'
$stdout.puts "It took #{Time.now - last_time} seconds to load refinerycms-authentication"
last_time = Time.now
require 'refinerycms-settings'
$stdout.puts "It took #{Time.now - last_time} seconds to load refinerycms-settings"
last_time = Time.now
require 'refinerycms-images'
$stdout.puts "It took #{Time.now - last_time} seconds to load refinerycms-images"
last_time = Time.now
require 'refinerycms-resources'
$stdout.puts "It took #{Time.now - last_time} seconds to load refinerycms-resources"
last_time = Time.now
require 'refinerycms-pages'
$stdout.puts "It took #{Time.now - last_time} seconds to load refinerycms-pages"
last_time = Time.now
require 'refinerycms-dashboard'
$stdout.puts "It took #{Time.now - last_time} seconds to load refinerycms-dashboard"
$stdout.puts "It took #{Time.now - time} seconds to load all required engines."