module Refinery
  module <%= namespacing %>
    class <%= class_name %> < Refinery::Core::BaseModel
      <% if table_name == namespacing.underscore.pluralize -%>self.table_name = :refinery_<%= plural_name %><% end -%>
      <% if localized? %>translates <%= localized_attributes.collect{|a| ":#{a.name}"}.join(', ') %><% end %>
    <% if (string_attributes = attributes.select{ |a| a.type.to_s =~ /string|text/ }.uniq).any? %>
      acts_as_indexed :fields => <%= string_attributes.map{|s| s.name.to_sym}.inspect %>

      validates <%= string_attributes.first.inspect %>, :presence => true, :uniqueness => true
      <% else %>
      # def title was created automatically because you didn't specify a string field
      # when you ran the refinery:engine generator. <3 <3 Refinery CMS.
      def title
        "Override def title in vendor/engines/<%= namespacing %>/app/models/refinery/<%= namespacing %>/<%= singular_name %>.rb"
      end
      <% end -%>
    <% attributes.select{|a| a.type.to_s == 'image'}.uniq.each do |a| -%>

      belongs_to :<%= a.name.gsub("_id", "") -%>, :class_name => '::Refinery::Image'
    <% end -%>
    <% attributes.select{|a| a.type.to_s == 'resource'}.uniq.each do |a| -%>

      belongs_to :<%= a.name.gsub("_id", "") %>, :class_name => '::Refinery::Resource'
    <% end %>
    end
  end
end
