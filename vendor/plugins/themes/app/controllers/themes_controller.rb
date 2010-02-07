class ThemesController < ApplicationController

  def stylesheets
    render_theme_item(:stylesheets, params[:filepath])
  end

  def javascripts
    render_theme_item(:javascripts, params[:filepath])
  end

  def images
    render_theme_item(:images, params[:filepath])
  end

protected

  def render_theme_item(type, relative_path)
    if File.exist?(file_path = File.join(Rails.root, "themes", RefinerySetting[:theme], type.to_s, relative_path))
    	send_file(file_path, :type => mime_for(relative_path), :disposition => 'inline', :stream => true)
		else
			return error_404
		end
  end

  def mime_for(filename)
		# could we use the built in Rails mime types to work this out?
    case filename.last.downcase
    when /\.js$/
      'text/javascript; charset=utf-8'
    when /\.css$/
      'text/css; charset=utf-8'
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