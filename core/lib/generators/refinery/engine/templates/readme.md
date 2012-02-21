# <%= engine_plural_name.titleize %> engine for Refinery CMS.

## How to build this engine as a gem

    cd vendor/engines/<%= engine_plural_name %>
    gem build refinerycms-<%= engine_plural_name %>.gemspec
    gem install refinerycms-<%= engine_plural_name %>.gem

    # Sign up for a http://rubygems.org/ account and publish the gem
    gem push refinerycms-<%= engine_plural_name %>.gem