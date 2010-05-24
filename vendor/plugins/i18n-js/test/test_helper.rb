require "rubygems"
require "test/unit"
require "mocha"

begin
  require "active_support/all"
rescue LoadError
  require "active_support"
end

require "active_support/test_case"
require "ostruct"
require "pathname"
require "i18n"
require "json"
require "fakeweb"

FakeWeb.allow_net_connect = false

# Stub Rails.root, so we don"t need to load the whole Rails environment.
# Be careful! The specified folder will be removed!
Rails = OpenStruct.new(:root => Pathname.new(File.dirname(__FILE__) + "/tmp"))

require File.dirname(__FILE__) + "/../lib/i18n-js"
