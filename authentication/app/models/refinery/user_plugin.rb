module Refinery
  class UserPlugin < Refinery::Core::BaseModel

    belongs_to :user
    attr_accessible :user_id, :name, :position

  end
end
