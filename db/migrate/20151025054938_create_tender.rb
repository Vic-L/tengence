class CreateTender < ActiveRecord::Migration
  def change
    create_table :tenders, id: false, primary_key: :ref_no do |t|
      t.string :ref_no
      t.string :buyer_company_name
      t.string :buyer_name
      t.string :buyer_contact_number
      t.string :buyer_email
      t.text :description
      t.date :published_date
      t.datetime :closing_datetime
      t.string :external_link, limit: 2083
      t.string :status, default: 'active'
    end

    add_index :tenders, :ref_no, unique: true
  end
end

