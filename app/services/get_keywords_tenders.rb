class GetKeywordsTenders
  include Service
  include Virtus.model

  attribute :keywords, String
  attribute :user, User
  attribute :params, Hash

  def call

    ## use thinking sphinx
    begin
      set_sort_order

      thinking_sphinx_ids = []
      (user.keywords || '').split(",").each do |keyword|
        # get tenders for each keyword belonging to a user
        thinking_sphinx_ids << Tender.search_for_ids(keyword).to_a
      end
      thinking_sphinx_ids = thinking_sphinx_ids.flatten.compact.uniq #remove any duplicate tender ref nos

      eval("@tenders = CurrentTender.includes(:users).where(thinking_sphinx_id: thinking_sphinx_ids).#{@sort}")
      @results_count = @tenders.size
      @tenders = @tenders.page(params['page']).per(50)

      @current_page = @tenders.current_page
      @total_pages = @tenders.total_pages
      @last_page = @tenders.last_page?
      @tenders = @tenders.to_a
      @watched_tender_ids = user.watched_tenders.where(tender_id: @tenders.map(&:ref_no)).pluck(:tender_id)

      return [@tenders, @current_page, @total_pages, @last_page, @results_count, @watched_tender_ids]
    rescue => e
      NotifyViaSlack.delay.call(content: "<@vic-l> Error GetKeywordsTenders.rb (using thinking-sphinx)\r\n#{e.message}\r\n#{e.backtrace.to_s}")
    end


    # begin
    #   results_ref_nos = []
    #   (user.keywords || '').split(",").each do |keyword|
    #     # get tenders for each keyword belonging to a user
    #     results_ref_nos << AwsManager.search(keyword: keyword)
    #   end
    #   results_ref_nos = results_ref_nos.flatten.compact.uniq #remove any duplicate tender ref nos

    #   eval("@tenders = CurrentTender.includes(:users).where(ref_no: results_ref_nos).#{@sort}")
    #   @results_count = @tenders.size
    #   @tenders = @tenders.page(params['page']).per(50)

    #   @current_page = @tenders.current_page
    #   @total_pages = @tenders.total_pages
    #   @last_page = @tenders.last_page?
    #   @tenders = @tenders.to_a
    #   @watched_tender_ids = user.watched_tenders.where(tender_id: @tenders.map(&:ref_no)).pluck(:tender_id)

    #   return [@tenders, @current_page, @total_pages, @last_page, @results_count, @watched_tender_ids]
    # rescue => e
    #   NotifyViaSlack.delay.call(content: "<@vic-l> Error GetKeywordsTenders.rb\r\n#{e.message}\r\n#{e.backtrace.to_s}")
    # end

  end

  private
    def only_watched_tenders?
      !source.blank? && source == 'watched_tenders'
    end

    def set_sort_order
      case params['sort']
      when 'newest'
        @sort = "order(published_date: :desc)"
      when 'expiring'
        @sort = "order(closing_datetime: :asc)"
      else
        @sort = "order(published_date: :desc)"
      end
    end
end