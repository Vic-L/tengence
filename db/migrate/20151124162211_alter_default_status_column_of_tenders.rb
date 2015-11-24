class AlterDefaultStatusColumnOfTenders < ActiveRecord::Migration
  def change
    change_column_default :tenders, :status, "open"
    # redefine tender views every time a migration that changes the tender table is run
    execute("CREATE OR REPLACE VIEW #{ActiveRecord::Base.connection.current_database}.current_tenders AS
            SELECT *
            FROM tenders
            WHERE closing_datetime >= NOW()
              AND status = 'open'")
    execute("CREATE OR REPLACE VIEW #{ActiveRecord::Base.connection.current_database}.past_tenders AS
            SELECT * 
            FROM tenders 
            WHERE closing_datetime < NOW()")
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
