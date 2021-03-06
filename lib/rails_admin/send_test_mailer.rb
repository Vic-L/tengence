module RailsAdmin
  module Config
    module Actions
      class SendTestMailer < RailsAdmin::Config::Actions::Base
        # This ensures the action only shows up for Users
        register_instance_option :visible? do
          authorized? && bindings[:object].class == User
        end
        # We want the action on members, not the Users collection
        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-stop'
        end

        # You may or may not want pjax for your action
        register_instance_option :pjax? do
          false
        end

        register_instance_option :controller do
          Proc.new do
            begin
              if @object.keywords.blank?
                redirect_to back_or_index, flash: {error: "User (#{@object.email}) has no keywords."}
              else
                # new_tenders_ref_nos_array = CurrentTender.where(published_date: Time.now.in_time_zone('Asia/Singapore').to_date.yesterday).pluck(:ref_no)
                # if new_tenders_ref_nos_array.blank?
                #   redirect_to back_or_index, flash: {error: "There are no new tenders published yesterday."}
                # else
                  thinking_sphinx_ids = []
                  (@object.keywords || '').split(",").each do |keyword|
                    # get tenders for each keyword belonging to a user
                    thinking_sphinx_ids << Tender.search_for_ids(keyword, {per_page: TS_MAX_PER_PAGE}).to_a
                  end
                  thinking_sphinx_ids = thinking_sphinx_ids.flatten.compact.uniq #remove any duplicate tender ref nos

                  if Time.now.in_time_zone('Asia/Singapore').to_date.monday?
                    current_tenders_ref_nos = CurrentTender.where(thinking_sphinx_id: thinking_sphinx_ids).where("published_date >= ?", Time.now.in_time_zone('Asia/Singapore').to_date - 3.days).pluck(:ref_no) # get all tenders published from friday
                  else
                    current_tenders_ref_nos = CurrentTender.where(thinking_sphinx_id: thinking_sphinx_ids, published_date: Time.now.in_time_zone('Asia/Singapore').to_date.yesterday).pluck(:ref_no)
                  end

                  if current_tenders_ref_nos.blank?
                    redirect_to back_or_index, flash: {error: "There are no tenders matching #{@object.email}'s keywords that were published yesterday."}
                  else
                    InternalMailer.alert_mail(@object.id, current_tenders_ref_nos, current_tenders_ref_nos.size).deliver_later
                    # current_tenders_ref_nos.each do |ref_no|
                    #   WatchedTender.delay(:retry => true).create(tender_id: ref_no, user_id: @object.id)
                    # end
                    redirect_to back_or_index, flash: {success: "Alert Email has been sent to #{@object.email}."}
                  end
                # end
              end
            rescue => e
              redirect_to back_or_index, flash: {error: "Error in email rake for user #{@object.email}. \r\n#{e.message}\r\n\r\n#{e.backtrace.to_s}"}
            end
          end
        end
      end
    end
  end
end