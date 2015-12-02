class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :uploadable, :polymorphic => true, index: true

      t.timestamps null: false
    end
  end
end
