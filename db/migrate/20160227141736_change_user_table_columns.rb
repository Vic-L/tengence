class ChangeUserTableColumns < ActiveRecord::Migration
  def change
    remove_column :users, :braintree_subscription_id
    add_column :users, :subscribed_plan, :string, default: "free_plan"
    add_column :users, :auto_renew, :boolean, default: false
  end
end
