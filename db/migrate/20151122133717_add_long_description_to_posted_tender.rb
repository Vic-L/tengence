class AddLongDescriptionToPostedTender < ActiveRecord::Migration
  def change
    add_column :tenders, :long_description, :text
  end
end
