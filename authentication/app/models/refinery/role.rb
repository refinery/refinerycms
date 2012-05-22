module Refinery
  class Role < Refinery::Core::BaseModel

    has_and_belongs_to_many :users, :join_table => :refinery_roles_users

    before_validation :camelize_title
    validates :title, :uniqueness => true

    def camelize_title(role_title = self.title)
      self.title = role_title.to_s.camelize
    end

    def self.[](title)
      (title.to_s.camelize)
    end

  end
end
