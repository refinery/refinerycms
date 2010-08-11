require 'digest/sha1'

class User < ActiveRecord::Base
  #-------------------------------------------------------------------------------------------------
  # Authentication

  # See http://rdoc.info/rdoc/binarylogic/authlogic/blob/85b2a6b3e9993b18c7fb1e4f7b9c6d01cc8b5d17/Authlogic/ActsAsAuthentic
  acts_as_authentic do |c|
    c.perishable_token_valid_for 10.minutes

    # http://www.binarylogic.com/2008/11/23/tutorial-easily-migrate-from-restful_authentication-to-authlogic/
    # Unfortunately, this seems to cause problems when you add Refinery to an app that already had
    # an Authlogic-created users table. You may need to comment these 2 lines out if that is the case.
    c.act_like_restful_authentication = true
    c.transition_from_restful_authentication = true

    # If users prefer to use their e-mail address to log in, change this setting to 'email' in
    # config/application.rb
    # This currently only affects which field is displayed in the login form. As long as we have
    # find_by_login_method :find_by_login_or_email, they can still actually use either one.
    c.login_field = defined?(Refinery.authentication_login_field) ? Refinery.authentication_login_field : "login"
  end if self.table_exists?

  # Allow users to log in with either their username *or* email, even though we only ask for one of those.
  def self.find_by_login_or_email(login_or_email)
    find_by_login(login_or_email) || find_by_email(login_or_email)
  end

  def deliver_password_reset_instructions!(request)
    reset_perishable_token!
    UserMailer.deliver_reset_notification(self, request)
  end

  #-------------------------------------------------------------------------------------------------

  has_and_belongs_to_many :roles
  has_many :plugins, :class_name => "UserPlugin", :order => "position ASC"
  has_friendly_id :login, :use_slug => true

  def plugins=(plugin_names)
    unless self.new_record? # don't add plugins when the user_id is NULL.
      self.plugins.delete_all

      plugin_names.each_with_index do |plugin_name, index|
        self.plugins.create(:name => plugin_name, :position => index) if plugin_name.is_a?(String)
      end
    end
  end

  def authorized_plugins
    self.plugins.collect { |p| p.name } | Refinery::Plugins.always_allowed.names
  end

  def can_delete?(user_to_delete = self)
    !user_to_delete.new_record? and
      !user_to_delete.has_role?(:superuser) and
      Role[:refinery].users.count > 1 and
      self.id != user_to_delete.id
  end

  def add_role(title)
    raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(Role)
    self.roles << Role[title] unless self.has_role?(title)
  end

  def has_role?(title)
    raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(Role)
    (role = Role.find_by_title(title.to_s.camelize)).present? and self.roles.collect{|r| r.id}.include?(role.id)
  end

end
