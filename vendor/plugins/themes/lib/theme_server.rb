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

      if (file_path = Rails.root.join "themes", RefinerySetting[:theme], relative_path).exist?
        [200, {"Content-Type" => Rack::Mime.mime_type(File.extname file_path)}, file_path.open]
      else
        [404, {"Content-Type" => "text/html"}, ["404 file not found."]]
      end
    else
      status, headers, response = @app.call(env)
      [status, headers, response]
    end
  end
  
end