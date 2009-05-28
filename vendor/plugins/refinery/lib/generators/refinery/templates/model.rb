class <%= class_name %> < ActiveRecord::Base
  
  validates_presence_of :<%= attributes.first.name %>
  validates_uniqueness_of :<%= attributes.first.name %>
  
end