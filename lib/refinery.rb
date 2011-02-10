time = Time.now
require 'refinerycms-base'
require 'refinerycms-core'

require 'refinerycms-authentication'
require 'refinerycms-settings'
require 'refinerycms-images'
require 'refinerycms-resources'
require 'refinerycms-pages'
require 'refinerycms-dashboard'
$stdout.puts "It took #{Time.now - time} to load all required engines."