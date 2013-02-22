ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  
  create_table :fruits, :force => true do |t|
    t.string  :type
    t.string  :color
    t.boolean :peeled
  end
  
end
