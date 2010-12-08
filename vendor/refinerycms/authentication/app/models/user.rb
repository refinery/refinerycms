require 'digest/sha1'

class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :plugins, :class_name => "UserPlugin", :order => "position ASC", :dependent => :destroy
  has_friendly_id :login, :use_slug => true
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login, :plugins

  def plugins=(plugin_names)
    if self.persisted? # don't add plugins when the user_id is nil.
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
    user_to_delete.persisted? and
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
