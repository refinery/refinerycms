module Refinery
  class UserLocale < Refinery::Core::BaseModel

    belongs_to :user
    attr_accessible :user_id, :locale

    default_scope { order('locale asc') }

  end
end
