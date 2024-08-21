class AddProfilePicIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :profile_pic_id, :integer, default: 1
  end
end
