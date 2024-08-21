class AddStatusAndTrackIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :status, :string,  default: 'Order placed'
    add_column :orders, :address_id, :string
    add_column :orders, :track_id, :string
    
  end
end
