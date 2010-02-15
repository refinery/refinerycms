# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

# Servers theme files from the them directory without touching Rails too much
class ThemeServer

  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] =~ /^\/theme/
      relative_path = env["PATH_INFO"].gsub(/^\/theme\//, '')

      if (file_path = Rails.root.join("themes", RefinerySetting[:theme], relative_path)).exist?
        # generate an etag for client-side caching.
        etag = Digest::MD5.hexdigest("#{file_path.to_s}#{file_path.mtime}")
        unless (env["HTTP_IF_NONE_MATCH"] == etag and RefinerySetting.find_or_set(:themes_use_etags, false))
          [200, {
                  "Content-Type" => Rack::Mime.mime_type(file_path.extname),
                  "ETag" => etag
                }, file_path.open]
        else
          [304, {"Content-Type" => Rack::Mime.mime_type(file_path.extname)}, "Not Modified"]
        end
      else
        [404, {"Content-Type" => "text/html"}, ["Not Found"]]
      end
    else
      status, headers, response = @app.call(env)
      [status, headers, response]
    end
  end

end