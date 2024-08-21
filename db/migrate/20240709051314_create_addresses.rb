class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|

      t.integer :user_id
      t.string :house_number
      t.string :street
      t.string :landmark
      t.text :direction_to_reach
      t.string :address_type
      

      t.timestamps
    end
  end
end
