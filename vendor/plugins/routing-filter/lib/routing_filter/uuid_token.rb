# This is a routing filter that extracts UUIDs from urls and exposes them via
# params[:uuid_token]
#
# URL scheme: http://example.com/d00fbbd1-82b6-4c1a-a57d-098d529d6854/your_route
#
# To enable this filter add map.filter :uuid_token to your routes.rb
#
# To make your restful path helpers use this :uuid_token use:
# new_post_path(:uuid_token => params[:uuid_token])
#
# If don't want to pass the :uuid_token manually you can add a custom module
# like this to your RAILS_ROOT/lib directory:
#
#   module AccessToken
#
#     class << self
#       def current=(token)
#         Thread.current[:uuid_token] = token
#       end
#
#       def current
#         Thread.current[:uuid_token] ||= ""
#       end
#     end
#
#   end
#
# Now in your application_controller you can set a before_filter which sets that
# token for every request:
#
#   before_filter :set_token
#
#   protected
#
#     def set_token
#       AccessToken.current = params[:uuid_token] if params[:uuid_token]
#     end
#
# As you can see below in the around_generate method, if you don't provide a
# :uuid_token argument for your restful path helpers it will try to get the
# current :uuid_token from the AccessToken module.

require 'routing_filter/base'

module RoutingFilter
  class UuidToken < Base

    def around_recognize(path, env, &block)
      token = extract_token!(path)                              # remove the token from the beginning of the path
      returning yield do |params|                               # invoke the given block (calls more filters and finally routing)
        params[:uuid_token] = token if token                    # set recognized token to the resulting params hash
      end
    end

    def around_generate(*args, &block)
      token = args.extract_options!.delete(:uuid_token)         # extract the passed :token option
      token = AccessToken.current if AccessToken && token.nil?  # default to AccessToken.current when token is nil (could also be false)

      returning yield do |result|
        if token
          url = result.is_a?(Array) ? result.first : result
          prepend_token!(url, token)
        end
      end
    end

    protected

      def extract_token!(path)
        path.sub! /([a-z\d]{8}\-[a-z\d]{4}\-[a-z\d]{4}\-[a-z\d]{4}\-[a-z\d]{12})\//, ''
        $1
      end

      def prepend_token!(url, token)
        url.sub!(%r(^(http.?://[^/]*)?(.*))) { "#{$1}/#{token}#{$2}" }
      end
  end
end
