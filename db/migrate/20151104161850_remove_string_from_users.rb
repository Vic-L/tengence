class RemoveStringFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :string
  end
end
