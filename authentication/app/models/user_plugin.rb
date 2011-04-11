class UserPlugin < ActiveRecord::Base

  belongs_to :user
  attr_accessible :user_id, :name, :position

end
