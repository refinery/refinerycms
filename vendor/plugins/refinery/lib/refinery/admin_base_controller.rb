class Refinery::AdminBaseController < ApplicationController

  layout proc { |controller| "admin#{"_dialog" if controller.from_dialog?}" }

  before_filter :redirect_if_old_url, :correct_accept_header, :login_required, :restrict_plugins, :restrict_controller
  after_filter :store_location?, :except => [:new, :create, :edit, :update, :destroy, :update_positions] # for redirect_back_or_default

  helper_method :searching?

  def admin?
    true # we're in the admin base controller, so always true.
  end

  def searching?
    params[:search].present?
  end

protected

  #TODO Add language
  def error_404(exception=nil)
    if (@page = Page.find_by_menu_match("^/404$", :include => [:parts, :slugs])).present?
      params[:action] = 'error_404'
      # change any links in the copy to the admin_root_url
      # and any references to "home page" to "Dashboard"
      part_symbol = Page.default_parts.first.to_sym
      @page[part_symbol] = @page[part_symbol].gsub(
                            /href=(\'|\")\/(\'|\")/, "href='#{admin_root_url(:only_path => true)}'"
                           ).gsub("home page", "Dashboard")

      render :template => "/pages/show", :status => 404
    else
      # fallback to the default 404.html page.
      render :file => Rails.root.join("public", "404.html").cleanpath.to_s, :layout => false, :status => 404
    end
  end

  def find_or_set_locale
    if (params[:set_locale].present? and ::Refinery::I18n.locales.include?(params[:set_locale].to_sym))
      ::Refinery::I18n.current_locale = params[:set_locale].to_sym
      redirect_to url_for({:controller => controller_name, :action => action_name}) and return
    else
      I18n.locale = ::Refinery::I18n.current_locale
    end
  end

  def group_by_date(records)
    new_records = []

    records.each do |record|
      key = record.created_at.strftime("%Y-%m-%d")
      record_group = new_records.collect{|records| records.last if records.first == key }.flatten.compact << record
      (new_records.delete_if {|i| i.first == key}) << [key, record_group]
    end

    new_records
  end

  def restrict_plugins
    Refinery::Plugins.set_active(current_user.authorized_plugins) if current_user.respond_to?(:plugins)
  end

  def restrict_controller
    if Refinery::Plugins.active.reject { |plugin|
      params[:controller] !~ Regexp.new(plugin.menu_match) and
      params[:controller] !~ Regexp.new(plugin.menu_match.to_s.gsub('admin\/', 'refinery/'))
    }.empty?
      logger.warn "'#{current_user.login}' tried to access '#{params[:controller]}' but was rejected."
      error_404
    end
  end

  # Override method from application_controller. Not needed in this controller.
  def find_pages_for_menu; end


private
  # This fixes the issue where Internet Explorer browsers are presented with a basic auth dialogue
  # rather than the xhtml one that they *can* accept but don't think they can.
  def correct_accept_header
    if request.user_agent =~ /MSIE (6|7|8)/
      if request.accept == "*/*"
        request.env["HTTP_ACCEPT"] = request.cookies[:http_accept] ||= "application/xml"
      else
        request.cookies[:http_accept] = (request.env["HTTP_ACCEPT"] = (["text/html"] | request.accept.split(', ')).join(', '))
      end
    end
  end

  # Just a simple redirect for old urls.
  def redirect_if_old_url
    redirect_to request.path.gsub('admin', 'refinery') if request.path =~ /^(|\/)admin/
  end

  # Check whether it makes sense to return the user to the last page they
  # were at instead of the default e.g. admin_pages_url
  # right now we just want to snap back to index actions and definitely not to dialogues.
  def store_location?
    store_location unless action_name !~ /index/ or request.xhr? or from_dialog?
  end

  # Override authorized? so that only users with the Refinery role can admin the website.
  def authorized?
    refinery_user?
  end

end
