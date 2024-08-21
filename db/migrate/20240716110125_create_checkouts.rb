class CreateCheckouts < ActiveRecord::Migration[6.1]
  def change
    create_table :checkouts do |t|
      t.integer :user_id
      t.integer :shop_id
      t.jsonb :total_services, null: false, default: '{}'
      t.integer :grand_total


      t.timestamps
    end
    add_index :checkouts, [:shop_id]
  end
end
