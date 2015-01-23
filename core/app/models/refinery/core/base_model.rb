require 'active_record'

module Refinery
  module Core
    class BaseModel < ActiveRecord::Base
      self.abstract_class = true

      def users_manager
        @users_manager ||= Refinery::Core::UsersManager.new
      end
    end
  end
end
