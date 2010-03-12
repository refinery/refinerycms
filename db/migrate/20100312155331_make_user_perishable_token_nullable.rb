class MakeUserPerishableTokenNullable < ActiveRecord::Migration
  def self.up
    change_table "users" do |t|
      t.change    :perishable_token , :string , :null => true                # optional
    end
  end

  def self.down
    change_table "users" do |t|
      t.change    :perishable_token , :string , :null => false               # optional
    end
  end
end
