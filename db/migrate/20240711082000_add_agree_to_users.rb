class AddAgreeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :agree, :boolean
  end
end
