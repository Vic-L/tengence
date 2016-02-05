class TendersController < ApplicationController
  before_action :store_location
  before_action :authenticate_user!
  before_action :deny_read_only_access, except: [:show]
  before_action :deny_write_only_access, only: [:show]
  before_action :deny_unconfirmed_users
  before_action :check_inhouse_tender, only: [:edit, :update]
  before_action :check_own_tender, only: [:edit, :update]

  def new
    @tender = Tender.new(ref_no: "InHouse-#{Time.now.in_time_zone('Asia/Singapore').to_formatted_s(:number)}", published_date: Time.now.in_time_zone('Singapore').to_date, buyer_company_name: current_user.company_name, postee_id: current_user.id)
    @tender.documents.build
  end

  def create
    @tender = Tender.new tender_params
    @tender.save
    if @tender.persisted?
      flash[:success] = "Tender Created Successfully!"
      redirect_to current_posted_tenders_path
    else
      flash[:alert] = @tender.errors.full_messages.to_sentence
      NotifyViaSlack.call(content: "<@vic-l> Error uploading tender by #{current_user.email}\r\n#{@tender.errors.full_messages.to_sentence}")
      redirect_to new_tender_path
    end
  end

  def show
    @tender = Tender.find_by(ref_no: params[:id])
  end

  def edit
    if @tender.past?
      flash[:alert] = 'The tender you want to edit is expired and cannot be edited.'
      redirect_to current_posted_tenders_path
    end
  end

  def update
    if @tender.update(tender_params)
      flash[:success] = "Buying requirement successfully updated!"
    else
      flash[:alert] = "#{@tender.errors.full_messages.to_sentence}"
    end
    redirect_to :back
  end

  private
    def check_own_tender
      # check_inhouse_tender already checked presence of postee_id
      if current_user.id != @tender.postee_id
        flash[:alert] = 'This tender does not belong to you. You are not authorized to edit it.'
        redirect_to current_posted_tenders_path
      end
    end

    def check_inhouse_tender
      if params[:id]
        @tender = Tender.find(params[:id])
      elsif tender_params[:ref_no]
        @tender = Tender.find(tender_params[:ref_no])
      end
      if !@tender.in_house?
        flash[:alert] = 'This tender is not editable.'
        redirect_to current_posted_tenders_path
      end
    end

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
        :closing_datetime,
        :postee_id,
        :description,
        :long_description,
        documents_attributes: [
          :id,
          :upload,
          :_destroy
        ]
      )
    end
end