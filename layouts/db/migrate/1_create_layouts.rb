class CreateLayouts < ActiveRecord::Migration
  def self.up
    create_table :layouts do |t|
      t.string :title
      t.string :template_name

      t.timestamps
    end

    add_column :pages, :layout_id, :integer
    add_index :layouts, :id

    load(Rails.root.join('db', 'seeds', 'layouts.rb'))
  end

  def self.down
    UserPlugin.destroy_all({:name => "layouts"})

    Page.delete_all({:link_url => "/layouts"})

    drop_table :layouts
  end
end
