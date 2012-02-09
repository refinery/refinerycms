class Create<%= namespacing %><%= class_name.pluralize %> < ActiveRecord::Migration

  def self.up
    create_table :refinery_<%= "#{namespacing.underscore}_" if table_name != namespacing.underscore.pluralize -%><%= table_name %> do |t|
<%
  attributes.each do |attribute|
    # turn image or resource into what it was supposed to be which is an integer reference to an image or resource.
    if attribute.type.to_s =~ /^(image|resource)$/
      attribute.type = 'integer'
      attribute.name = "#{attribute.name}_id".gsub("_id_id", "_id")
    elsif attribute.type.to_s =~ /^(radio|select)$/
      attribute.type = 'string'
    elsif attribute.type.to_s =~ /^(checkbox)$/
      attribute.type = 'boolean'
    end
-%>
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>

      t.timestamps
    end

    add_index :refinery_<%= "#{namespacing.underscore}_" if table_name != namespacing.underscore.pluralize -%><%= table_name %>, :id

    if (seed = Rails.root.join('db', 'seeds', '<%= class_name.pluralize.underscore.downcase %>.rb')).exist?
      load(seed)
    end
  end

  def self.down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-<%= namespacing.underscore %>"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/<%= namespacing.underscore %>/<%= plural_name %>"})
    end

    drop_table :refinery_<%= "#{namespacing.underscore}_" if table_name != namespacing.underscore.pluralize -%><%= table_name %>
  end

end
