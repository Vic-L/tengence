class CreateViewedTenders < ActiveRecord::Migration
  def change
    create_table :viewed_tenders do |t|
      t.string :ref_no, index:true
      t.references :user, index: true

      t.timestamps
    end
  end
end
