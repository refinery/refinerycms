class AddSpamToInquiries < ActiveRecord::Migration

  def self.up
    add_column :inquiries, :spam, :boolean, :default => false
  end

  def self.down
    remove_column :inquiries, :spam
  end

end
