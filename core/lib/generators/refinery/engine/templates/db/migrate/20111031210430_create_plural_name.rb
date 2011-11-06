class Create<%= class_name.pluralize %> < ActiveRecord::Migration

  def up
    create_table :refinery_<%= table_name %> do |t|
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

    Refinery::<%= class_name.pluralize %>::Engine.load_seed
  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "<%= class_name.pluralize.underscore.downcase %>"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/<%= plural_name %>"})
    end

    drop_table :refinery_<%= table_name %>
  end

end
