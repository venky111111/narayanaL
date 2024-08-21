class CreateWorkspaces < ActiveRecord::Migration[6.1]
  def change
    create_table :workspaces do |t|
      t.string :title
      t.text :content
      t.string :image
      t.string :sub_title

      t.timestamps
    end
  end
end
