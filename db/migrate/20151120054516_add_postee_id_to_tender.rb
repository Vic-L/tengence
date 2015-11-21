class AddPosteeIdToTender < ActiveRecord::Migration
  def change
    add_column :tenders, :postee_id, :integer, default: nil, index: true
  end
end
