class RemoveUnusedUsersColumns < ActiveRecord::Migration
  def self.up
    change_table "users" do |t|
      t.remove    :activated_at
      t.remove    :deleted_at
    end
  end

  def self.down
    change_table "users" do |t|
      t.datetime "activated_at"
      t.datetime "deleted_at"
    end
  end
end

