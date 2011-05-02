require 'devise'

class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :plugins, :class_name => "UserPlugin", :order => "position ASC", :dependent => :destroy
  has_friendly_id :username, :use_slug => true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # :login is a virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :plugins, :login

  validates :username, :presence => true, :uniqueness => true

  class << self
    # Configure authentication_keys here instead of devise.rb initialzer so we don't overwrite standard devise models
    def authentication_keys
      [:login]
    end

    # Find user by email or username.
    # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign_in-using-their-username-or-email-address
    def find_for_database_authentication(conditions)
      value = conditions[authentication_keys.first]
      where(["username = :value OR email = :value", { :value => value }]).first
    end
  end

  def plugins=(plugin_names)
    if persisted? # don't add plugins when the user_id is nil.
      UserPlugin.delete_all(:user_id => id)

      plugin_names.each_with_index do |plugin_name, index|
        plugins.create(:name => plugin_name, :position => index) if plugin_name.is_a?(String)
      end
    end
  end

  def authorized_plugins
    plugins.collect { |p| p.name } | Refinery::Plugins.always_allowed.names
  end

  def can_delete?(user_to_delete = self)
    user_to_delete.persisted? and
    id != user_to_delete.id and
    !user_to_delete.has_role?(:superuser) and
    Role[:refinery].users.count > 1
  end

  def add_role(title)
    raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(Role)
    roles << Role[title] unless has_role?(title)
  end

  def has_role?(title)
    raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(Role)
    roles.any?{|r| r.title == title.to_s.camelize}
  end

end
