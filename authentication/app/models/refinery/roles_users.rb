module Refinery
  class RolesUsers < Refinery::Core::Base

    belongs_to :role
    belongs_to :user

  end
end
