require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'bundler/setup'

# If you have a Gemfile, require the default gems, the ones in the
# current environment and also include :assets gems if in development
# or test environments.
Bundler.require *Rails.groups(:assets)

require 'refinerycms'

<%= application_definition %>
