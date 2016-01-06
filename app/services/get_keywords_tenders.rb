class GetKeywordsTenders
  include Service
  include Virtus.model

  attribute :keywords, String
  attribute :user, User
  attribute :params, Hash

  def call
    begin
      results_ref_nos = []
      user.keywords.split(",").each do |keyword|
        # get tenders for each keyword belonging to a user
        results = AwsManager.search(keyword: keyword)
        results_ref_nos << results.hits.hit.map do |result|
          result.fields["ref_no"][0]
        end
      end
      results_ref_nos = results_ref_nos.flatten.compact.uniq #remove any duplicate tender ref nos
      @tenders = CurrentTender.includes(:users).where(ref_no: results_ref_nos)
      @results_count = @tenders.size
      @tenders = @tenders.page(params[:page]).per(50)

      @current_page = @tenders.current_page
      @total_pages = @tenders.total_pages
      @limit_value = @tenders.limit_value
      @last_page = @tenders.last_page?
      @tenders = @tenders.to_a
      @watched_tender_ids = user.watched_tenders.where(tender_id: @tenders.map(&:ref_no)).pluck(:tender_id)

      return [@tenders, @current_page, @total_pages, @limit_value, @last_page, @results_count, @watched_tender_ids]
    rescue => e
      NotifyViaSlack.call(content: "<@vic-l> Error GetKeywordsTenders.rb\r\n#{e.message}\r\n#{e.backtrace.to_s}")
    end

  end

  private
    def only_watched_tenders?
      !source.blank? && source == 'watched_tenders'
    end
end