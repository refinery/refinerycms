module Refinery
  module Helpers
    module ScriptHelper

      # This function helps when including both the jquery and jqueryui libraries.
      # If you use this function then whenever we update or relocate the version of jquery or jquery ui in use
      # we will update the reference here and your existing application starts to use it.
      # Use <%= jquery_include_tags %> to include it in your <head> section.
      def jquery_include_tags(options={})
        # Merge in options
        options = {
          :caching => RefinerySetting.find_or_set(:use_resource_caching, Rails.root.writable?),
          :google => RefinerySetting.find_or_set(:use_google_ajax_libraries, false),
          :jquery_ui => true
        }.merge(options)

        # render the tags normally unless
        unless options[:google] and !local_request?
          if options[:jquery_ui]
            javascript_include_tag  "jquery#{"-min" if Rails.env.production?}", "jquery-ui-custom-min",
                                    :cache => (options[:caching] ? "cache/jquery" : nil)
          else
            javascript_include_tag "jquery#{"-min" if Rails.env.production?}"
          end
        else
          "#{javascript_include_tag("http://www.google.com/jsapi").gsub(".js", "")}
          <script type='text/javascript'>
            google.load('jquery', '1.4');
            #{"google.load('jqueryui', '1.8');" if options[:jquery_ui]}
          </script>".html_safe
        end
      end

    end
  end
end
