module Refinery
  class Images::Thumb < Refinery::Core::BaseModel
    validates_uniqueness_of :job, :uid
    attr_accessible :job, :uid
  end
end