class <%= class_name %> < ActiveRecord::Base

  acts_as_indexed :fields => [:<%= attributes.collect{ |attribute| attribute.name if attribute.type.to_s =~ /string|text/ }.compact.uniq.join(", :") %>]

  validates_presence_of :<%= attributes.first.name %>
  validates_uniqueness_of :<%= attributes.first.name %>

<% attributes.collect{|a| a if a.type.to_s == 'image'}.compact.uniq.each do |a| -%>
  belongs_to :<%= a.name.gsub("_id", "") %><%= ", :class_name => 'Image'" unless a.name =~ /^image(_id)?$/ %>
<% end -%>
<% attributes.collect{|a| a if a.type.to_s == 'resource'}.compact.uniq.each do |a| -%>
  belongs_to :<%= a.name.gsub("_id", "") %><%= ", :class_name => 'Resource'" unless a.name =~ /^resource(_id)?$/ %>
<% end -%>


end
