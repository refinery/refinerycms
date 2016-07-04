require 'refinery/core/base_model'

module Refinery
  class Site < Core::BaseModel
    has_many :pages
    self.table_name = 'refinery_sites'
    attr_accessible :name, :hostname
    validates :name, :presence => true, :uniqueness => true
  end
end
