module Refinery
  module ScriptHelper

    # This function helps when including both the jquery and jqueryui libraries.
    # If you use this function then whenever we update or relocate the version of jquery or jquery ui in use
    # we will update the reference here and your existing application starts to use it.
    # Use <%= jquery_include_tags %> to include it in your <head> section.
    def jquery_include_tags(options={})
      # Merge in options
      options = {
        :caching => (Rails.root.writable? and ::Refinery::Setting.find_or_set(:use_resource_caching, true)),
        :google => ::Refinery::Setting.find_or_set(:use_google_ajax_libraries, false),
        :jquery_ui => true
      }.merge(options)

      # render the tags normally unless
      unless options[:google] and !local_request?
        if options[:jquery_ui]
          javascript_include_tag  "jquery#{"-min" if Rails.env.production?}", "jquery-ui-custom-min",
                                  :cache => ("cache/jquery" if options[:caching])
        else
          javascript_include_tag "jquery#{"-min" if Rails.env.production?}"
        end
      else
        "#{javascript_include_tag("http://www.google.com/jsapi").gsub(".js", "")}
        <script>
          google.load('jquery', '1.5.2');
          #{"google.load('jqueryui', '1.8.9');" if options[:jquery_ui]}
        </script>".html_safe
      end
    end

  end
end
