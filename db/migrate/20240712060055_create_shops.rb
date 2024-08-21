class CreateShops < ActiveRecord::Migration[6.1]
  def change
    create_table :shops do |t|

        t.string :shop_name
        t.string :city


      t.timestamps
    end
  end
end
