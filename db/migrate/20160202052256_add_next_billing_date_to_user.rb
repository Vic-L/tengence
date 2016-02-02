class AddNextBillingDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :next_billing_date, :date, default: nil
  end
end
