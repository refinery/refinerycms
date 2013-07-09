module Refinery
  class UserLocale < Refinery::Core::BaseModel

    belongs_to :user
    attr_accessible :user_id, :locale

    default_scope { order('locale asc') }

    def self.users_with_locale(locale)
      where(locale: locale).map(&:user)
    end

  end
end
