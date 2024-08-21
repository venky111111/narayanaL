class CreateServicesAssigneds < ActiveRecord::Migration[6.1]
  def change
    create_table :services_assign do |t|

      t.integer :shop_id, null: false
      t.integer :item_id, null: false
      t.integer :service_id, null: false

      t.integer :price

      t.timestamps

    end
     add_index :services_assign, [:shop_id, :item_id, :service_id]
  end
end
