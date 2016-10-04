class GetDemoTenders
  include Service
  include Virtus.model

  attribute :params, Hash
  attribute :table, String

  def call
    ## use thinking sphinx
    begin
      unless params['query'].blank?
        thinking_sphinx_ids = Tender.search_for_ids(params['query'], {per_page: TS_MAX_PER_PAGE}).to_a

        eval("@tenders = #{table}.non_sesami.where(thinking_sphinx_id: thinking_sphinx_ids).order(published_date: :desc)")
        @results_count = @tenders.count
        @tenders = @tenders.page(params['page']).per(10)
      else
        eval("@tenders = #{table}.non_sesami.order(published_date: :desc).page(params['page']).per(10)")
        eval("@results_count = #{table}.count")
      end

      @current_page = @tenders.current_page
      @total_pages = @tenders.total_pages
      @last_page = @tenders.last_page?
      @tenders = @tenders.to_a
      @watched_tender_ids = []

      return [@tenders, @current_page, @total_pages, @last_page, @watched_tender_ids, @results_count]
    rescue => e
      NotifyViaSlack.delay.call(content: "<@vic-l> Error GetDemoTenders.rb\r\n#{e.message}\r\n#{e.backtrace.to_s}")
    end

    # begin
    #   unless params['query'].blank?
    #     results_ref_nos = AwsManager.search(keyword: params['query'])

    #     eval("@tenders = #{table}.non_sesami.where(ref_no: results_ref_nos).order(published_date: :desc)")
    #     @results_count = @tenders.count
    #     @tenders = @tenders.page(params['page']).per(10)
    #   else
    #     eval("@tenders = #{table}.non_sesami.order(published_date: :desc).page(params['page']).per(10)")
    #     eval("@results_count = #{table}.count")
    #   end

    #   @current_page = @tenders.current_page
    #   @total_pages = @tenders.total_pages
    #   @last_page = @tenders.last_page?
    #   @tenders = @tenders.to_a
    #   @watched_tender_ids = []

    #   return [@tenders, @current_page, @total_pages, @last_page, @watched_tender_ids, @results_count]
    # rescue => e
    #   NotifyViaSlack.delay.call(content: "<@vic-l> Error GetDemoTenders.rb\r\n#{e.message}\r\n#{e.backtrace.to_s}")
    # end
  end
end