class CreatePageTemplates < ActiveRecord::Migration
  def self.up
    add_column :pages, :view_template, :string

    load(Rails.root.join('db', 'seeds', 'page_templates.rb'))
  end

  def self.down
    remove_column :pages, :view_template
  end
end
