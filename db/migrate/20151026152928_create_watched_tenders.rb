class CreateWatchedTenders < ActiveRecord::Migration
  def change
    create_table :watched_tenders do |t|
      t.references :users, index: true
      t.references :tenders, index: true

      t.timestamps
    end
  end
end
