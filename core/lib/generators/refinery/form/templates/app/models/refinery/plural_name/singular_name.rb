module Refinery
  module <%= class_name.pluralize %>
    class <%= class_name %> < Refinery::Core::BaseModel

      acts_as_indexed :fields => [:<%= attributes.collect{ |a| a.name if a.type.to_s =~ /string|text/ }.compact.uniq.join(", :") %>]

      # Add some validation here if you want to validate the user's input

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
