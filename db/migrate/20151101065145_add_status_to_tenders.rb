class AddStatusToTenders < ActiveRecord::Migration
  def change
    add_column :tenders, :status, :string, default: 'active'
  end
end
