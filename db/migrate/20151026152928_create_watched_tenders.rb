class CreateWatchedTenders < ActiveRecord::Migration
  def change
    create_table :watched_tenders do |t|
      t.references :user, index: true
      t.string :tender_id, index: true

      t.timestamps
    end
  end
end
