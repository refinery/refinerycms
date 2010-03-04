module ThemesHelper
  def image_tag(source, options={})
    theme = (options.delete(:theme) == true)
    tag = super
    # inject /theme/ into the image tag src if this is themed.
    tag.gsub!(/src=[\"|\']/) { |m| "#{m}/theme/" }.gsub!("//", "/") if theme
    tag.gsub(/theme=(.+?)\ /, '') # we need to remove any addition of theme='false' etc.
  end

  def javascript_include_tag(*sources)
    theme = (arguments = sources.dup).extract_options![:theme] == true # don't ruin the current sources object
    tag = super
    # inject /theme/ into the javascript include tag src if this is themed.
    tag.gsub!(/\/javascripts\//, "/theme/javascripts/") if theme
    tag.gsub(/theme=(.+?)\ /, '') # we need to remove any addition of theme='false' etc.
  end

  def stylesheet_link_tag(*sources)
    theme = (arguments = sources.dup).extract_options![:theme] == true # don't ruin the current sources object
    tag = super
    # inject /theme/ into the stylesheet link tag href if this is themed.
    tag.gsub!(/\/stylesheets\//, "/theme/stylesheets/") if theme
    tag.gsub(/theme=(.+?)\ /, '') # we need to remove any addition of theme='false' etc.
  end

  def image_submit_tag(source, options = {})
    theme = (options.delete(:theme) == true)

    tag = super
    # inject /theme/ into the image tag src if this is themed.
    tag.gsub!(/src=[\"|\']/) { |m| "#{m}/theme/" }.gsub!("//", "/") if theme
    tag.gsub(/theme=(.+?)\ /, '') # we need to remove any addition of theme='false' etc.
  end
end
