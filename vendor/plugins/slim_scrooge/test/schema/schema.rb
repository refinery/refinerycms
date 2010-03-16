ActiveRecord::Schema.define do
  create_table :courses, :force => true do |t|
    t.column :name, :string, :null => false
  end
end
