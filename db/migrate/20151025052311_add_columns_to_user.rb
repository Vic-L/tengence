class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :company_name, :string, null: false
    add_column :users, :keywords, :text
  end
end
