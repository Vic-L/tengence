class AddColumnsToTenders < ActiveRecord::Migration
  def change
    add_column :tenders, :category, :string, default: nil
    add_column :tenders, :remarks, :text
  end
end
