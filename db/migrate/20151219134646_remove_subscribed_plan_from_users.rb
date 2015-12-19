class RemoveSubscribedPlanFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :subscribed_plan
  end
end
