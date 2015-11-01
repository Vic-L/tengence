class CreateCurrentTendersPastTendersView < ActiveRecord::Migration
  def change
    execute("CREATE OR REPLACE VIEW #{ActiveRecord::Base.connection.current_database}.current_tenders AS
            SELECT *
            FROM tenders
            WHERE closing_datetime >= NOW()
              AND status = 'open'")
    execute("CREATE OR REPLACE VIEW #{ActiveRecord::Base.connection.current_database}.past_tenders AS
            SELECT * FROM tenders WHERE closing_datetime < NOW()
              AND status = 'open'")
  end
end
