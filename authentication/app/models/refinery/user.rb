require 'devise'
require 'friendly_id'

module Refinery
  class User < Refinery::Core::BaseModel
    extend FriendlyId

    has_and_belongs_to_many :roles, join_table: :refinery_roles_users

    has_many :plugins, -> { order('position ASC') },
                       class_name: "UserPlugin", dependent: :destroy

    friendly_id :username, use: [:slugged]

    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable, :lockable and :timeoutable
    if self.respond_to?(:devise)
      devise :database_authenticatable, :registerable, :recoverable, :rememberable,
             :trackable, :validatable, authentication_keys: [:login]
    end

    # Setup accessible (or protected) attributes for your model
    # :login is a virtual attribute for authenticating by either username or email
    # This is in addition to a real persisted field like 'username'
    attr_accessor :login
    attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :plugins, :login, :full_name

    validates :username, presence: true, uniqueness: true
    before_validation :downcase_username, :strip_username

    class << self
      # Find user by email or username.
      # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign_in-using-their-username-or-email-address
      def find_for_database_authentication(conditions)
        value = conditions[authentication_keys.first]
        where(["username = :value OR email = :value", { value: value }]).first
      end
    end

    def plugins=(plugin_names)
      return unless persisted?

      plugin_names = plugin_names.dup
      plugin_names.reject! { |plugin_name| !plugin_name.is_a?(String) }

      if plugins.empty?
        plugin_names.each_with_index do |plugin_name, index|
          plugins.create(:name => plugin_name, :position => index)
        end
      else
        assigned_plugins = plugins.all
        assigned_plugins.each do |assigned_plugin|
          if plugin_names.include?(assigned_plugin.name)
            plugin_names.delete(assigned_plugin.name)
          else
            assigned_plugin.destroy
          end
        end

        plugin_names.each do |plugin_name|
          if plugin_name.is_a?(String)
            plugins.create name: plugin_name,
                           position: plugins.select(:position).map{|p| p.position.to_i}.max + 1
          end
        end
      end
    end

    def authorized_plugins
      plugins.collect(&:name) | ::Refinery::Plugins.always_allowed.names
    end

    def can_delete?(user_to_delete = self)
      user_to_delete.persisted? &&
        !user_to_delete.has_role?(:superuser) &&
        ::Refinery::Role[:refinery].users.any? &&
        id != user_to_delete.id
    end

    def can_edit?(user_to_edit = self)
      user_to_edit.persisted? && (user_to_edit == self || self.has_role?(:superuser))
    end

    def add_role(title)
      raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(::Refinery::Role)
      roles << ::Refinery::Role[title] unless has_role?(title)
    end

    def has_role?(title)
      raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(::Refinery::Role)
      roles.any?{|r| r.title == title.to_s.camelize}
    end

    def create_first
      if valid?
        # first we need to save user
        save
        # add refinery role
        add_role(:refinery)
        # add superuser role if there are no other users
        add_role(:superuser) if ::Refinery::Role[:refinery].users.count == 1
        # add plugins
        self.plugins = Refinery::Plugins.registered.in_menu.names
      end

      # return true/false based on validations
      valid?
    end

    def to_s
      (full_name.presence || username).to_s
    end

    private
    # To ensure uniqueness without case sensitivity we first downcase the username.
    # We do this here and not in SQL is that it will otherwise bypass indexes using LOWER:
    # SELECT 1 FROM "refinery_users" WHERE LOWER("refinery_users"."username") = LOWER('UsErNAME') LIMIT 1
    def downcase_username
      self.username = self.username.downcase if self.username?
    end

    # To ensure that we aren't creating "admin" and "admin " as the same thing.
    # Also ensures that "admin user" and "admin    user" are the same thing.
    def strip_username
      self.username = self.username.strip.gsub(/\ {2,}/, ' ') if self.username?
    end

  end
end
