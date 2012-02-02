class Create<%= namespacing %><%= class_name.pluralize %> < ActiveRecord::Migration

  def up
    create_table :refinery_<%= "#{namespacing.underscore}_" if table_name != namespacing.underscore.pluralize -%><%= table_name %> do |t|
<%
  attributes.each do |attribute|
    # turn image or resource into what it was supposed to be which is an integer reference to an image or resource.
    if attribute.type.to_s =~ /^(image|resource)$/
      attribute.type = 'integer'
      attribute.name = "#{attribute.name}_id".gsub("_id_id", "_id")
    end
-%>
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>
      t.integer :position

      t.timestamps
    end

    Refinery::<%= namespacing %>::Engine.load_seed
  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-<%= namespacing.underscore %>"})
    end

<% unless skip_frontend? %>
    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/<%= namespacing.underscore %>/<%= plural_name %>"})
    end
<% end %>
    drop_table :refinery_<%= "#{namespacing.underscore}_" if table_name != namespacing.underscore.pluralize -%><%= table_name %>
  end

end
