class CreateRefinerycmsPagesSchema < ActiveRecord::Migration[4.2]
  def change
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

    create_table :refinery_page_part_translations do |t|

      # Translated attribute(s)
      t.text :body

      t.string  :locale, null: false
      t.integer :refinery_page_part_id, null: false

      t.timestamps null: false
    end

    add_index :refinery_page_part_translations, :locale, name: :index_refinery_page_part_translations_on_locale
    add_index :refinery_page_part_translations, [:refinery_page_part_id, :locale], name: :index_93b7363baf444ecab114aab0bbdedc79d0ec4f4b, unique: true

    create_table :refinery_page_translations do |t|

      # Translated attribute(s)
      t.string :title
      t.string :custom_slug
      t.string :menu_title
      t.string :slug

      t.string  :locale, null: false
      t.integer :refinery_page_id, null: false

      t.timestamps null: false
    end

    add_index :refinery_page_translations, :locale, name: :index_refinery_page_translations_on_locale
    add_index :refinery_page_translations, [:refinery_page_id, :locale], name: :index_refinery_page_t10s_on_refinery_page_id_and_locale, unique: true
  end
end
