# <%= plural_name.titleize %> engine for Refinery CMS.

## How to build this engine as a gem

    cd vendor/engines/<%= plural_name %>
    gem build refinerycms-<%= plural_name %>.gemspec
    gem install refinerycms-<%= plural_name %>.gem
    
    # Sign up for a http://rubygems.org/ account and publish the gem
    gem push refinerycms-<%= plural_name %>.gem