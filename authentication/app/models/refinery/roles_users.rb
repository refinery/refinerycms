module Refinery
  class RolesUsers < Refinery::Core::BaseModel

    belongs_to :role
    belongs_to :user

  end
end
