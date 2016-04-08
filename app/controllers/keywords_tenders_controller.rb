class KeywordsTendersController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_chosen_users
  before_action :deny_write_only_access
  before_action :deny_unconfirmed_users

  def index
    @current_tenders_count = CurrentTender.count
    @keywords = current_user.keywords
    # results_ref_nos = []
    # current_user.keywords.split(",").each do |keyword|
    #   # get tenders for each keyword belonging to a user
    #   results_ref_nos << AwsManager.search(keyword: keyword)
    # end
    # results_ref_nos = results_ref_nos.flatten.compact.uniq #remove any duplicate tender ref nos
    # tenders = CurrentTender.includes(:users).where(ref_no: results_ref_nos)
    # @tenders = tenders.page(params[:page]).per(50)
    # @results_count = tenders.size

    # atom feed variable
    # if request.format.symbol == :atom
    #   @latest_updated_datetime = tenders.maximum(:published_date)
    # end
  end

  def update_keywords
    current_user.keywords = params[:keywords]
    if current_user.valid?
      if current_user.save
        flash[:success] = "Your keywords are updated"
        cookies.delete(:keywords)
        redirect_to keywords_tenders_path
      else
        flash[:alert] = "Error in updating keywords. Our team are onto this. Sorry for the inconvenience caused"
        cookies[:keywords] = params[:keywords]
        # internal mailer
        redirect_to keywords_tenders_path
      end
    else
      flash[:alert] = "Too many keywords"
      cookies[:keywords] = params[:keywords]
      # internal mailer
      redirect_to keywords_tenders_path
    end
  end
end
