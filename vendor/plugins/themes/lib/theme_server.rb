# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

# Serves theme files from the theme directory without touching Rails too much
class ThemeServer

  def initialize(app)
    @app = app
  end

  def call(env)
    relative_path = env["PATH_INFO"].gsub(/^\/theme\//, '')
    if (env["PATH_INFO"]) =~ /^\/theme/ and (file_path=Rails.root.join("themes", RefinerySetting[:theme], relative_path)).exist?
      unless ((etag = Digest::MD5.hexdigest("#{file_path.to_s}#{file_path.mtime}")) == env["HTTP_IF_NONE_MATCH"])
        env["PATH_INFO"] = relative_path
        status, headers, body = Rack::File.new(Rails.root.join("themes", RefinerySetting[:theme])).call(env)
        [status, headers.update({"ETag" => etag}), body]
      else
        [304, {"ETag" => etag}, []]
      end
    else
      @app.call(env)
    end
  end

end