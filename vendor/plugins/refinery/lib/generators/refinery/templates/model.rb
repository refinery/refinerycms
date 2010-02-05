class <%= class_name %> < ActiveRecord::Base

  acts_as_indexed :fields => [:<%= attributes.collect{ |attribute| attribute.name if attribute.type.to_s =~ /string|text/ }.compact.uniq.join(", :") %>],
                  :index_file => %W(#{RAILS_ROOT} tmp index)

  validates_presence_of :<%= attributes.first.name %>
  validates_uniqueness_of :<%= attributes.first.name %>

end