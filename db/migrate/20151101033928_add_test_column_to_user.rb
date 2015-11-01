class AddTestColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :test, :boolean
  end
end
