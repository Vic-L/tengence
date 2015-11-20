class AddBudgetToTenders < ActiveRecord::Migration
  def change
    add_column :tenders, :budget, :string
  end
end
