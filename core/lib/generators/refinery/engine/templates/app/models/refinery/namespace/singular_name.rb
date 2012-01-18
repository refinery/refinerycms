module Refinery
  module <%= namespacing %>
    class <%= class_name %> < Refinery::Core::Base
      <% if table_name == namespacing.underscore.pluralize -%>set_table_name :refinery_<%= plural_name %><% end -%>
    <% if (string_attributes = attributes.map{ |attribute| attribute.name.to_sym if attribute.type.to_s =~ /string|text/ }.compact.uniq).any? %>
      acts_as_indexed :fields => <%= string_attributes.inspect %>

      validates <%= string_attributes.first.inspect %>, :presence => true, :uniqueness => true
      <% else %>
      # def title was created automatically because you didn't specify a string field
      # when you ran the refinery:engine generator. <3 <3 Refinery CMS.
      def title
        "Override def title in vendor/engines/<%= namespacing %>/app/models/refinery/<%= namespacing %>/<%= singular_name %>.rb"
      end
      <% end -%>
    <% attributes.collect{|a| a if a.type.to_s == 'image'}.compact.uniq.each do |a| -%>

      belongs_to :<%= a.name.gsub("_id", "") -%>, :class_name => '::Refinery::Image'
    <% end -%>
    <% attributes.collect{|a| a if a.type.to_s == 'resource'}.compact.uniq.each do |a| -%>

      belongs_to :<%= a.name.gsub("_id", "") %>, :class_name => '::Refinery::Resource'
    <% end %>
    end
  end
end
