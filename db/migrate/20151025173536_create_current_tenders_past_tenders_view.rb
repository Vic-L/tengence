class CreateCurrentTendersPastTendersView < ActiveRecord::Migration
  def change
    if Rails.env.development?
      execute("CREATE OR REPLACE VIEW tengence_dev.current_tenders AS
                SELECT *
                FROM tenders
                WHERE closing_datetime > NOW()")
      execute("CREATE OR REPLACE VIEW tengence_dev.past_tenders AS
                SELECT *
                FROM tenders
                WHERE closing_datetime <= NOW()")
    end
  end
end
