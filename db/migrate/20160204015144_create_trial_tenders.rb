class CreateTrialTenders < ActiveRecord::Migration
  def change
    create_table :trial_tenders, id: false do |t|
      t.references :user, index: true
      t.references :tender, index: true
    end

    add_column :users, :trial_tenders_count, :integer, default: 0
  end
end
