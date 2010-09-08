class <%= class_name %> < ActiveRecord::Base

  acts_as_indexed :fields => [:<%= attributes.collect{ |attribute| attribute.name if attribute.type.to_s =~ /string|text/ }.compact.uniq.join(", :") %>]
  <% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? %>
  validates_presence_of :<%= title.name %>
  validates_uniqueness_of :<%= title.name %>
  <% end -%>

<% attributes.collect{|a| a if a.type.to_s == 'image'}.compact.uniq.each do |a| -%>
  belongs_to :<%= a.name.gsub("_id", "") %><%= ", :class_name => 'Image'" unless a.name =~ /^image(_id)?$/ %>
<% end -%>
<% attributes.collect{|a| a if a.type.to_s == 'resource'}.compact.uniq.each do |a| -%>
  belongs_to :<%= a.name.gsub("_id", "") %><%= ", :class_name => 'Resource'" unless a.name =~ /^resource(_id)?$/ %>
<% end -%>


end
