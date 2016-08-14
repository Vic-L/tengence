class AddThinkingSphinxIdToTenders < ActiveRecord::Migration
  def change
    add_column :tenders, :thinking_sphinx_id, :integer, unique: true, index: true, null: false
  end
end
