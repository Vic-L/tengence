class CreateCurrentPastPostedTendersView < ActiveRecord::Migration
  def change
    execute("CREATE OR REPLACE VIEW #{ActiveRecord::Base.connection.current_database}.current_posted_tenders AS
            SELECT *
            FROM tenders
            WHERE ref_no LIKE 'InHouse%'
              AND closing_datetime >= NOW()")
    execute("CREATE OR REPLACE VIEW #{ActiveRecord::Base.connection.current_database}.past_posted_tenders AS
            SELECT * 
            FROM tenders 
            WHERE ref_no LIKE 'InHouse%'
              AND closing_datetime < NOW()")
  end
end
