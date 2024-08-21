class AddDeliveryDateToCheckouts < ActiveRecord::Migration[6.1]
  def change
  
    add_column :checkouts, :delivery_date, :date
  end
end
