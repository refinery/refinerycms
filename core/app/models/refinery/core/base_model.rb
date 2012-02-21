# If any changes are made to this class then the application will require a restart
# This is because this class is added to autoload_once_paths in lib/refinery/core/engine.rb.
module Refinery
  module Core
    class BaseModel < ActiveRecord::Base

      self.abstract_class = true

    end
  end
end
