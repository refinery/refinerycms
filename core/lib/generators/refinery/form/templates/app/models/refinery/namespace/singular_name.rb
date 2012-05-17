module Refinery
  module <%= class_name.pluralize %>
    class <%= class_name %> < Refinery::Core::BaseModel
<% if table_name == namespacing.underscore.pluralize -%>
      self.table_name = 'refinery_<%= plural_name %>'
<% end %>
      attr_accessible <%= attributes.map { |attr| ":#{attr.name}" }.join(', ') %>, :position

<% if (text_or_string_fields = attributes.map{ |a| a.name if a.type.to_s =~ /string|text/ }.compact.uniq).any? -%>
      acts_as_indexed :fields => [:<%= text_or_string_fields.join(", :") %>]
<% end -%>
<% if (text_fields = attributes.map {|a| a.name if a.type.to_s == 'text'}.compact.uniq).any? && text_fields.detect{|a| a.to_s == 'message'}.nil? -%>
      alias_attribute :message, :<%= text_fields.first %>
<% elsif text_fields.empty? %>
      # def message was created automatically because you didn't specify a text field
      # when you ran the refinery:form generator. <3 <3 Refinery CMS.
      def message
        "Override def message in vendor/extensions/<%= namespacing.underscore %>/app/models/refinery/<%= namespacing.underscore %>/<%= singular_name %>.rb"
      end
<% end %>
<% unless (string_fields = attributes.map{ |a| a.name if a.type.to_s == 'string' }.compact.uniq).empty? || string_fields.detect{|f| f.to_s == 'name'} %>
      alias_attribute :name, :<%= string_fields.first %>
<% end %>
      # Add some validation here if you want to validate the user's input
<% if string_fields.any? -%>
      # We have validated the first string field for you.
      validates :<%= string_fields.first %>, :presence => true
<% else %>
      # def name was created automatically because you didn't specify a string field
      # when you ran the refinery:form generator. <3 <3 Refinery CMS.
      def name
        "Override def name in vendor/extensions/<%= namespacing.underscore %>/app/models/refinery/<%= namespacing.underscore %>/<%= singular_name %>.rb"
      end
<% end -%>
<% if @includes_spam -%>

      filters_spam :message_field => :message, :extra_spam_words => %w()
<% end %>
<% attributes.select{|a| a.type.to_s == 'image'}.uniq.each do |a| -%>

      belongs_to :<%= a.name.gsub("_id", "") -%>, :class_name => '::Refinery::Image'
<% end -%>
<% attributes.select{|a| a.type.to_s == 'resource'}.uniq.each do |a| -%>

      belongs_to :<%= a.name.gsub("_id", "") %>, :class_name => '::Refinery::Resource'
<% end -%>
<% attributes.select{|a| a.type.to_s =~ /radio|select/}.uniq.each do |a| -%>
      <%= a.name.pluralize.upcase %> = []
<% end -%>
    end
  end
end
