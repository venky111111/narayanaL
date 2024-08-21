class AddCheckupDateToCheckouts < ActiveRecord::Migration[6.1]
  def change
    add_column :checkouts, :pickup_date, :date
  end
end
