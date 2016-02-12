class AddDefaultValueToAccessLevelOfUser < ActiveRecord::Migration
  def change
    change_column_default :users, :access_level, 'read_only'
  end
end
