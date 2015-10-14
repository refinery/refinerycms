require "rubygems"
require "google/api_client"

module Refinery
  class GoogleOauth

    def initialize(client_id, client_secret)
      @client_id     = client_id
      @client_secret = client_secret
    end

    def get_oauth_object()
      client = Google::APIClient.new(:application_name => 'Refinery CMS registration extension', :application_version => '0.1')
      auth = client.authorization
      auth.client_id     = @client_id
      auth.client_secret = @client_secret
      auth.scope =
        "https://www.googleapis.com/auth/drive " +
        "https://spreadsheets.google.com/feeds/"
      return auth
    end

    def get_oauth_url(callback_url)
      result = 'error_getting_oauth_url'

      begin
        auth = get_oauth_object()
        auth.redirect_uri = callback_url
        result = "#{auth.authorization_uri}&approval_prompt=force"
      rescue => e
        Rails.logger.warn "There was an error authenticating with google drive. (to get auth url)\n#{e.message}\n"
      end

      return result
    end

    def get_refresh_token(callback_url, the_code)
      result = ''

      begin
        auth = get_oauth_object()
        auth.redirect_uri = callback_url
        auth.grant_type = "authorization_code"
        auth.code = the_code
        auth.fetch_access_token!
        result = auth.refresh_token
      rescue => e
        Rails.logger.warn "There was an error authenticating with google drive. (to get refresh_token)\n#{e.message}\n"
      end

      return result
    end

    def get_access_token(refresh_token)
      result = ''

      begin
        auth = get_oauth_object()
        auth.refresh_token = refresh_token
        auth.fetch_access_token!
        result = auth.access_token
      rescue => e
        Rails.logger.warn "There was an error authenticating with google drive. (to get access_token)\n#{e.message}\n"
      end

      return result
    end
  end
end
