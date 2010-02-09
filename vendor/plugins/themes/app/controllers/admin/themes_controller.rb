class Admin::ThemesController < Admin::BaseController

  crudify :theme, :order => "updated_at DESC"

  before_filter :find_theme, :only => [:update, :destroy, :edit, :preview_image, :activate]

  # accessor method for theme preview image
  def preview_image
    if File.exists? @theme.preview_image
      send_file(@theme.preview_image, :type => 'image/png',
                                      :disposition => 'inline',
                                      :stream => true)
    else
      return error_404
    end
  end

  def activate
    RefinerySetting[:theme] = @theme.folder_title

    flash[:notice] = "'#{@theme.title}' applied to live site."
    redirect_to admin_themes_url
  end

end
