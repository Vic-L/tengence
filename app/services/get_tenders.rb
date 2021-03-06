class GetTenders
  include Service
  include Virtus.model

  attribute :params, Hash
  attribute :table, String
  attribute :user, User
  attribute :source, String

  def call
    begin
      set_sort_order
      unless params['query'].blank?
        NotifyViaSlack.delay.call(content: "Non Demo Search by #{user.email}: #{params['query']}")

        thinking_sphinx_ids = Tender.search_for_ids(params['query'], {per_page: TS_MAX_PER_PAGE}).to_a
        
        if only_watched_tenders?
          watched_tender_ids = user.watched_tenders.pluck(:tender_id)
          tender_ts_ids = Tender.where(ref_no: watched_tender_ids).pluck(:thinking_sphinx_id)
          thinking_sphinx_ids = thinking_sphinx_ids & tender_ts_ids
        end

        if user.subscribed?
          eval("@tenders = #{table}.where(thinking_sphinx_id: thinking_sphinx_ids).#{@sort}")
        else
          eval("@tenders = #{table}.non_sesami.where(thinking_sphinx_id: thinking_sphinx_ids).#{@sort}")
        end
        @results_count = @tenders.count
        @tenders = @tenders.page(params['page']).per(50)
      else
        if only_watched_tenders?
          if user.subscribed?
            eval("@tenders = #{table}.non_sesami.where(ref_no: user.watched_tenders.pluck(:tender_id)).#{@sort}")
          else
            eval("@tenders = #{table}.where(ref_no: user.watched_tenders.pluck(:tender_id)).#{@sort}")
          end
          @results_count = @tenders.count
          @tenders = @tenders.page(params['page']).per(50)
        else
          if user.subscribed?
            eval("@tenders = #{table}.#{@sort}.page(params['page']).per(50)")
          else
            eval("@tenders = #{table}.non_sesami.#{@sort}.page(params['page']).per(50)")
          end
          eval("@results_count = #{table}.count")
        end
      end
      
      @current_page = @tenders.current_page
      @total_pages = @tenders.total_pages
      @last_page = @tenders.last_page?
      @tenders = @tenders.to_a
      @watched_tender_ids = user.watched_tenders.where(tender_id: @tenders.map(&:ref_no)).pluck(:tender_id)

      return [@tenders, @current_page, @total_pages, @last_page, @watched_tender_ids, @results_count]
    rescue => e
      NotifyViaSlack.delay.call(content: "<@vic-l> Error GetTenders.rb\r\n#{e.message}\r\n#{e.backtrace.to_s}")
    end

    # begin
    #   set_sort_order
    #   unless params['query'].blank?
    #     NotifyViaSlack.delay.call(content: "Non Demo Search by #{user.email}: #{params['query']}")

    #     results_ref_nos = AwsManager.search(keyword: params['query'])
        
    #     results_ref_nos = results_ref_nos & user.watched_tenders.pluck(:tender_id) if only_watched_tenders?

    #     if user.subscribed?
    #       eval("@tenders = #{table}.where(ref_no: results_ref_nos).#{@sort}")
    #     else
    #       eval("@tenders = #{table}.non_sesami.where(ref_no: results_ref_nos).#{@sort}")
    #     end
    #     @results_count = @tenders.count
    #     @tenders = @tenders.page(params['page']).per(50)
    #   else
    #     if only_watched_tenders?
    #       if user.subscribed?
    #         eval("@tenders = #{table}.non_sesami.where(ref_no: user.watched_tenders.pluck(:tender_id)).#{@sort}")
    #       else
    #         eval("@tenders = #{table}.where(ref_no: user.watched_tenders.pluck(:tender_id)).#{@sort}")
    #       end
    #       @results_count = @tenders.count
    #       @tenders = @tenders.page(params['page']).per(50)
    #     else
    #       if user.subscribed?
    #         eval("@tenders = #{table}.#{@sort}.page(params['page']).per(50)")
    #       else
    #         eval("@tenders = #{table}.non_sesami.#{@sort}.page(params['page']).per(50)")
    #       end
    #       eval("@results_count = #{table}.count")
    #     end
    #   end
      
    #   @current_page = @tenders.current_page
    #   @total_pages = @tenders.total_pages
    #   @last_page = @tenders.last_page?
    #   @tenders = @tenders.to_a
    #   @watched_tender_ids = user.watched_tenders.where(tender_id: @tenders.map(&:ref_no)).pluck(:tender_id)

    #   return [@tenders, @current_page, @total_pages, @last_page, @watched_tender_ids, @results_count]
    # rescue => e
    #   NotifyViaSlack.delay.call(content: "<@vic-l> Error GetTenders.rb\r\n#{e.message}\r\n#{e.backtrace.to_s}")
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