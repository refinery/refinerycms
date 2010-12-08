class Refinery::AdminBaseController < ApplicationController

  layout :layout?

  before_filter :authenticate_user!, :restrict_plugins, :restrict_controller
  after_filter :store_location?, :except => [:new, :create, :edit, :update, :destroy, :update_positions] # for redirect_back_or_default

  helper_method :searching?

  def admin?
    true # we're in the admin base controller, so always true.
  end

  def searching?
    params[:search].present?
  end

  def error_404(exception=nil)
    if (@page = Page.find_by_menu_match("^/404$", :include => [:parts, :slugs])).present?
      params[:action] = 'error_404'
      # change any links in the copy to the admin_root_url
      # and any references to "home page" to "Dashboard"
      part_symbol = Page.default_parts.first.to_sym
      @page[part_symbol] = @page[part_symbol].to_s.gsub(
                            /href=(\'|\")\/(\'|\")/, "href='#{admin_root_path}'"
                           ).gsub("home page", "Dashboard")

      render :template => "/pages/show",
             :layout => layout?,
             :status => 404
    else
      # fallback to the default 404.html page.
      render :file => Rails.root.join("public", "404.html").cleanpath.to_s,
             :layout => false,
             :status => 404
    end
  end

protected

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
    current_length = (plugins = current_user.authorized_plugins).length

    # Superusers get granted access if they don't already have access.
    if current_user.has_role?(:superuser)
      if (plugins = plugins | ::Refinery::Plugins.registered.names).length > current_length
        current_user.plugins = plugins
      end
    end

    Refinery::Plugins.set_active(plugins)
  end

  def restrict_controller
    if Refinery::Plugins.active.reject { |plugin| params[:controller] !~ Regexp.new(plugin.menu_match)}.empty?
      warn "'#{current_user.login}' tried to access '#{params[:controller]}' but was rejected."
      error_404
    end
  end

  # Override method from application_controller. Not needed in this controller.
  def find_pages_for_menu; end

private
  def layout?
    "admin#{"_dialog" if from_dialog?}"
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
