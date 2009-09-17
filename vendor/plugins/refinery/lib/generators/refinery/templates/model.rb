class <%= class_name %> < ActiveRecord::Base
  
	acts_as_indexed :fields => [:<%= attributes.collect{ |attribute| attribute.name }.join(", :") %>]

  validates_presence_of :<%= attributes.first.name %>
  validates_uniqueness_of :<%= attributes.first.name %>
  
end