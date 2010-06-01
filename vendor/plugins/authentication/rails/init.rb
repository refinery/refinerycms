Refinery::Plugin.register do |plugin|
  plugin.title = "Users"
  plugin.name = "refinery_users"
  plugin.description = "Manage users"
  plugin.version = 1.0
  plugin.menu_match = /(refinery|admin)\/users$/
  plugin.activity = {
    :class => User,
    :url_prefix => "edit_",
    :title => "login",
    :created_image => "user_add.png",
    :updated_image => "user_edit.png"
  }
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
  plugin.url = {:controller => "/refinery/users"}
end

module ::Refinery
  class << self
    attr_accessor :authentication_login_field
    def authentication_login_field
      @authentication_login_field ||= 'login'
    end
  end
end
