class GetTenders
  include Service
  include Virtus.model

  attribute :params, Hash
  attribute :table, String
  attribute :user, User

  def call
    begin
      unless params['query'].blank?
        results = AwsManager.search(keyword: params['query'])
        results_ref_nos = results.hits.hit.map do |result|
          result.fields["ref_no"][0]
        end
        eval("@tenders = #{table}.where(ref_no: results_ref_nos)")
        @results_count = @tenders.count
        @tenders = @tenders.page(params['page']).per(50)
      else
        eval("@results_count = #{table}.count")
        eval("@tenders = #{table}.page(params['page']).per(50)")
      end
      
      @current_page = @tenders.current_page
      @total_pages = @tenders.total_pages
      @limit_value = @tenders.limit_value
      @last_page = @tenders.last_page?
      @tenders = @tenders.to_a
      @watched_tender_ids = user.watched_tenders.where(tender_id: @tenders.map(&:ref_no)).pluck(:tender_id)

      return [@tenders, @current_page, @total_pages, @limit_value, @last_page, @watched_tender_ids, @results_count]
    rescue => e
      NotifyViaSlack.call(content: "<@vic-l> Error GetTenders.rb\r\n#{e.message}\r\n#{e.backtrace.to_s}")
    end
  end
end