class CreateRefinerycmsPagesSchema < ActiveRecord::Migration
  def up
    create_table :refinery_page_parts do |t|
      t.integer  :refinery_page_id
      t.string   :title
      t.text     :body
      t.integer  :position

      t.timestamps
    end

    add_index :refinery_page_parts, :id
    add_index :refinery_page_parts, :refinery_page_id

    create_table :refinery_pages do |t|
      t.integer   :parent_id
      t.integer   :position
      t.string    :path
      t.boolean   :show_in_menu,        :default => true
      t.string    :link_url
      t.string    :menu_match
      t.boolean   :deletable,           :default => true
      t.boolean   :draft,               :default => false
      t.boolean   :skip_to_first_child, :default => false
      t.integer   :lft
      t.integer   :rgt
      t.integer   :depth
      t.string    :view_template
      t.string    :layout_template
      # three following fields are just placeholders and they are removed
      # after creating page_translation table
      t.string    :meta_keywords
      t.string    :meta_description
      t.text      :browser_title

      t.timestamps
    end

    add_index :refinery_pages, :depth
    add_index :refinery_pages, :id
    add_index :refinery_pages, :lft
    add_index :refinery_pages, :parent_id
    add_index :refinery_pages, :rgt

    Refinery::PagePart.create_translation_table!({
      :body => :text
    })

    Refinery::Page.create_translation_table!({
      :title => :string,
      :custom_slug => :string,
      :menu_title => :string
    })

    Refinery::Page.reset_column_information

    [:meta_keywords, :meta_description, :browser_title].each do |field|
      remove_column :refinery_pages, field
    end
  end

  def down
    drop_table :refinery_page_parts
    drop_table :refinery_pages
    # Refinery::PagePart.drop_translation_table!
    # Refinery::Page.drop_translation_table!
  end
end
