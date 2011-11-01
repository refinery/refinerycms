class Create<%= class_name.pluralize %> < ActiveRecord::Migration

  def self.up
    create_table :<%= table_name %> do |t|
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

    add_index :<%= table_name %>, :id

    load(Rails.root.join('db', 'seeds', '<%= class_name.pluralize.underscore.downcase %>.rb'))
  end

  def self.down
    UserPlugin.destroy_all({:name => "<%= class_name.pluralize.underscore.downcase %>"})

    Page.delete_all({:link_url => "/<%= plural_name %>"})

    drop_table :<%= table_name %>
  end

end
