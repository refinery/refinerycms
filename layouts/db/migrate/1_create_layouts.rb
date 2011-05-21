class CreateLayouts < ActiveRecord::Migration
  def self.up
    add_column :pages, :layout_template, :string

    load(Rails.root.join('db', 'seeds', 'layouts.rb'))
  end

  def self.down
    remove_column :pages, :layout_template
  end
end
