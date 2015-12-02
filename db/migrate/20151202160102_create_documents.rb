class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :uploadable_id, index: true
      t.string :uploadable_type, index: true

      t.timestamps null: false
    end
  end
end
