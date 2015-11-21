class TendersController < ApplicationController
  before_action :store_location
  before_action :authenticate_user!
  before_action :deny_read_only_access, except: [:show]

  def new
    @tender = Tender.new(ref_no: "InHouse-#{Time.now.to_formatted_s(:number)}", published_date: Date.today, buyer_company_name: current_user.company_name, postee_id: current_user.id)
  end

  def create
    @tender = Tender.new tender_params
    @tender.save
    if @tender.persisted?
      flash[:success] = "Tender Created Successfully!"
      redirect_to current_posted_tenders_path
    else
      flash[:alert] = @tender.errors.full_messages.to_sentence
      redirect_to new_tender_path
    end
  end

  def show
    @tender = Tender.find_by(ref_no: params[:id])
  end

  private
    def store_location
      unless user_signed_in?
        store_location_for(:users, request.original_url)
      end
    end

    def tender_params
      params.require(:tender).permit(
        :ref_no,
        :published_date,
        :buyer_company_name,
        :buyer_name,
        :buyer_email,
        :buyer_contact_number,
        :budget,
        :closing_datetime,
        :postee_id,
        :description
      )
    end
end