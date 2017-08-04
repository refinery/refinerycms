class CreateRefinerycmsPagesSchema < ActiveRecord::Migration[4.2]
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
      t.string    :path
      t.string    :slug
      t.string    :custom_slug
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

      t.timestamps
    end

    add_index :refinery_pages, :depth
    add_index :refinery_pages, :id
    add_index :refinery_pages, :lft
    add_index :refinery_pages, :parent_id
    add_index :refinery_pages, :rgt

    begin
      ::Refinery::PagePart.create_translation_table!({
        :body => :text
      })
    rescue NameError
      warn "Refinery::PagePart was not defined!"
    end

    begin
      ::Refinery::Page.create_translation_table!({
        :title => :string,
        :custom_slug => :string,
        :menu_title => :string,
        :slug => :string
      })
    rescue NameError
      warn "Refinery::Page was not defined!"
    end
  end

  def down
    drop_table :refinery_page_parts
    drop_table :refinery_pages
    begin
      ::Refinery::PagePart.drop_translation_table!
    rescue NameError
      warn "Refinery::PagePart was not defined!"
    end
    begin
      ::Refinery::Page.drop_translation_table! if defined?(::Refinery::Page)
    rescue NameError
      warn "Refinery::Page was not defined!"
    end
  end
end
