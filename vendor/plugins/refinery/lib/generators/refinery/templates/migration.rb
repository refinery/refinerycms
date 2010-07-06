class <%= migration_name %> < ActiveRecord::Migration

  def self.up
    create_table :<%= table_name %> do |t|
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

    add_index :<%= table_name %>, :id

    load(Rails.root.join('db', 'seeds', '<%= class_name.pluralize.underscore.downcase %>.rb'))
  end

  def self.down
    UserPlugin.destroy_all({:name => "<%= class_name.pluralize.underscore.titleize %>"})

    Page.find_all_by_link_url("/<%= plural_name %>").each do |page|
      page.link_url, page.menu_match = nil
      page.deletable = true
      page.destroy
    end
    Page.destroy_all({:link_url => "/<%= plural_name %>"})

    drop_table :<%= table_name %>
  end

end
