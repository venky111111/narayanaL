class AddDefaultToAddresses < ActiveRecord::Migration[6.1]
  def change
     add_column :addresses, :default, :boolean, default: false
  end
end
