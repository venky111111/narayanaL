class AddImageToShops < ActiveRecord::Migration[6.1]
  def change
    add_column :shops, :shop_image, :string
    add_column :shops, :shop_number, :string
    add_column :shops, :street, :string
    add_column :shops, :landmark, :string
    add_column :shops, :pincode, :string
  end
end
