module Refinery
  class Manual < Refinery::Core::BaseModel

    attr_accessible :title, :attachment

    validates :title, presence: true
    validates :attachment, presence: true
    file_too_big_msg = "filesize limitation of 15MB exceeded. Please upload all files again."
    validates_size_of :attachment, maximum: 15.megabytes, message: file_too_big_msg

    def visible_as_content_manager?(user)
      return true if user.has_role?(:superuser)
      return false
    end
    
  end
end
