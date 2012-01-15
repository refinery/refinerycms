module Refinery
  module Core
    class Base < ActiveRecord::Base

      self.abstract_class = true

    end
  end
end