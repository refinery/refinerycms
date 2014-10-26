# <%= extension_plural_name.titleize %> extension for Refinery CMS.

## How to build this extension as a gem (not required)

    cd vendor/extensions/<%= extension_plural_name %>
    gem build refinerycms-<%= extension_plural_name %>.gemspec
    gem install refinerycms-<%= extension_plural_name %>.gem

    # Sign up for a https://rubygems.org/ account and publish the gem
    gem push refinerycms-<%= extension_plural_name %>.gem
