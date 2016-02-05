class CreateTrialTenders < ActiveRecord::Migration
  def change
    create_table :trial_tenders do |t|
      t.references :user, index: true
      t.string :tender_id, index: true
    end

    add_column :users, :trial_tenders_count, :integer, default: 0
  end
end
