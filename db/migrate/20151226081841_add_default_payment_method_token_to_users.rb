class AddDefaultPaymentMethodTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_payment_method_token, :string, default: nil
  end
end
