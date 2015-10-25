class CreateTender < ActiveRecord::Migration
  def change
    create_table :tenders do |t|
      t.string :ref_no
      t.string :buyer_company_name
      t.string :buyer_name
      t.string :buyer_contact_number
      t.string :buyer_email
      t.text :description
      t.date :published_date
      t.date :closing_date
      t.string :closing_time
    end
  end
end

