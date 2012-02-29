module Refinery
  module <%= class_name.pluralize %>
    class <%= class_name %> < Refinery::Core::BaseModel
      <% if table_name == namespacing.underscore.pluralize -%>self.table_name = :refinery_<%= plural_name %><% end -%>

      acts_as_indexed :fields => [:<%= (string_fields = attributes.collect{ |a| a.name if a.type.to_s =~ /string|text/ }.compact.uniq).join(", :") %>]

      # Add some validation here if you want to validate the user's input<% if string_fields.any? %>
      # We have validated the first string field for you.
      validates :<%= string_fields.first %>, :presence => true
      <% end -%>

    <% attributes.select{|a| a.type.to_s == 'image'}.uniq.each do |a| -%>

      belongs_to :<%= a.name.gsub("_id", "") -%>, :class_name => '::Refinery::Image'
    <% end -%>
    <% attributes.select{|a| a.type.to_s == 'resource'}.uniq.each do |a| -%>

      belongs_to :<%= a.name.gsub("_id", "") %>, :class_name => '::Refinery::Resource'
    <% end -%>
    <% attributes.select{|a| a.type.to_s =~ /radio|select/}.uniq.each do |a| %>
      <%= a.name.pluralize.upcase %> = []
    <% end %>
    end
  end
end
