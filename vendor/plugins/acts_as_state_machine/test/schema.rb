ActiveRecord::Schema.define(:version => 1) do
  create_table :conversations, :force => true do |t|
    t.column :state_machine, :string
    t.column :subject,       :string
    t.column :closed,        :boolean
  end
  
  create_table :people, :force => true do |t|
    t.column :name, :string
  end
end
