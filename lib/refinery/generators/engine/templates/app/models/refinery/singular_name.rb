module Refinery
  class <%= class_name %> < ActiveRecord::Base
  <% if (string_attributes = attributes.map{ |attribute| attribute.name.to_sym if attribute.type.to_s =~ /string|text/ }.compact.uniq).any? %>
    acts_as_indexed :fields => <%= string_attributes.inspect %>

    validates <%= string_attributes.first.inspect %>, :presence => true, :uniqueness => true
    <% else %>
    # def title was created automatically because you didn't specify a string field
    # when you ran the refinery:engine generator. <3 <3 Refinery CMS.
    def title
      "Override def title in vendor/engines/<%= plural_name %>/app/models/refinery/<%= singular_name %>.rb"
    end
    <% end -%>
  <% attributes.collect{|a| a if a.type.to_s == 'image'}.compact.uniq.each do |a| -%>

    belongs_to :<%= a.name.gsub("_id", "") -%><%= ", :class_name => '::Refinery::Image'" unless a.name =~ /^image(_id)?$/ -%>
  <% end -%>
  <% attributes.collect{|a| a if a.type.to_s == 'resource'}.compact.uniq.each do |a| -%>

    belongs_to :<%= a.name.gsub("_id", "") %><%= ", :class_name => '::Refinery::Resource'" unless a.name =~ /^resource(_id)?$/ -%>
  <% end %>
  end
end
