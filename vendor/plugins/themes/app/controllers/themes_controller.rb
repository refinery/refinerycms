class ThemesController < ApplicationController
 
  def stylesheets
    render_theme_item(:stylesheets, params[:filename], 'text/css; charset=utf-8')
  end
 
  def javascripts
    render_theme_item(:javascript, params[:filename], 'text/javascript; charset=utf-8')
  end
 
  def images
    render_theme_item(:images, params[:filename])
  end
 
protected
 
  def render_theme_item(type, file, mime = nil)
    mime ||= mime_for(file)

    file_path = RefinerySetting[:theme] + "/#{type}/#{file}"

 		if File.exists? file_path
    	send_file(file_path, :type => mime, :disposition => 'inline', :stream => true)
		else
			return error_404
		end
  end
 
  def mime_for(filename)
		# could we use the built in Rails mime types to work this out?
    case filename.downcase
    when /\.js$/
      'text/javascript'
    when /\.css$/
      'text/css'
    when /\.gif$/
      'image/gif'
    when /(\.jpg|\.jpeg)$/
      'image/jpeg'
    when /\.png$/
      'image/png'
    when /\.swf$/
      'application/x-shockwave-flash'
    else
      'application/binary'
    end
  end

end