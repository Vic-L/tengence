class GetPostedTenders
  include Service
  include Virtus.model

  attribute :params, Hash
  attribute :table, String
  attribute :user, User
  attribute :source, String

  def call
    begin
      set_sort_order
      # unless params['query'].blank?
      #   results_ref_nos = AwsManager.search(keyword: params['query'])

        eval("@tenders = #{table}.where(postee_id: user.id).#{@sort}")
        @results_count = @tenders.count
        @tenders = @tenders.page(params['page']).per(50)
      # else
      #   eval("@tenders = #{table}.#{@sort}.page(params['page']).per(50)")
      #   eval("@results_count = #{table}.count")
      # end
      
      @current_page = @tenders.current_page
      @total_pages = @tenders.total_pages
      @last_page = @tenders.last_page?
      @tenders = @tenders.to_a
      @watched_tender_ids = ''

      return [@tenders, @current_page, @total_pages, @last_page, @watched_tender_ids, @results_count]
    rescue => e
      NotifyViaSlack.delay.call(content: "<@vic-l> Error GetTenders.rb\r\n#{e.message}\r\n#{e.backtrace.to_s}")
    end

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