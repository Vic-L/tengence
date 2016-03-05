class BrainTreeController < ApplicationController
  before_action :authenticate_user!, except: [:sandbox_braintree_slack_pings, :braintree_slack_pings]
  before_action :deny_unconfirmed_users, except: [:sandbox_braintree_slack_pings, :braintree_slack_pings]
  before_action :deny_write_only_access, except: [:sandbox_braintree_slack_pings, :braintree_slack_pings]
  before_action :deny_unsubscribed_user, only: [:change_payment, :update_payment, :unsubscribe]
  before_action :deny_yet_to_subscribe_user, only: [:change_payment, :payment_history, :update_payment, :unsubscribe]
  skip_before_action :verify_authenticity_token, only: [:sandbox_braintree_slack_pings, :braintree_slack_pings]

  def billing
    @payment_method = Braintree::PaymentMethod.find(current_user.default_payment_method_token) if current_user.default_payment_method_token
  end

  def plans
  end

  def subscribe
    @plan = params[:plan]
    @client_token = Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
  end

  def change_payment
    @client_token = Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
    @payment_method = Braintree::PaymentMethod.find(current_user.default_payment_method_token) if current_user.default_payment_method_token
  end

  def payment_history
    @transactions = current_user.braintree.transactions
  end

  def update_payment

    resp = CreateNewPaymentMethod.call(
      braintree_customer_id: current_user.braintree_customer_id,
      payment_method_nonce: params[:payment_method_nonce])

    if resp[:status] == 'success'

      current_user.update!(default_payment_method_token: resp[:token])

      flash[:success] = 'You have successfully changed your default payment method'
      redirect_to billing_path

    elsif resp[:status] == 'error'

      flash[:alert] = resp[:message]
      redirect_to request.referrer

    else

      # binding.pry
      NotifyViaSlack.call(content: "This should not happen in brain_tree_controller#update_payment")

    end

  end

  def create_payment
    resp = CreateNewPaymentMethod.call(
      braintree_customer_id: current_user.braintree_customer_id,
      payment_method_nonce: params[:payment_method_nonce])

    if resp[:status] == 'success'

      resp = CreateSubscription.call(
        user: current_user,
        payment_method_token: resp[:token],
        plan: params[:plan],
        next_billing_date: current_user.next_billing_date,
        renew: params[:renew].present?
        )

      if resp[:status] == 'success'

        flash[:success] = resp[:message]
        redirect_to billing_path

      elsif resp[:status] == 'error'

        flash[:alert] = resp[:message]
        redirect_to request.referrer

      end

    elsif resp[:status] == 'error'

      flash[:alert] = resp[:message]
      redirect_to request.referrer

    else

      NotifyViaSlack.call(content: "This should not happen in brain_tree_controller#create_payment")

    end

  end

  def unsubscribe
    resp = UnsubscribeFromTengence.call(user: current_user)

    if resp[:status] == 'success'
      
      flash[:success] = resp[:message]
      redirect_to billing_path
    
    elsif resp[:status] == 'error'

      flash[:alert] = resp[:message]
      redirect_to request.referrer

    else

      NotifyViaSlack.call(content: "This should not happen in brain_tree_controller#unsubscribe")

    end
  end

  def toggle_renew
    begin
      current_user.update!(auto_renew: !current_user.auto_renew)
      respond_to do |format|
        format.json { render :json => current_user.auto_renew, status: :ok }
      end
    rescue => e
      NotifyViaSlack.call(content: "This should not happen in brain_tree_controller#unsubscribe")
      respond_to do |format|
        format.json { render :json => current_user.auto_renew, status: :internal_server_error }
      end
    end
  end

  def braintree_slack_pings
    webhook_notification = Braintree::WebhookNotification.parse(
      request.params["bt_signature"],
      request.params["bt_payload"]
    )
    content = "Braintree | #{webhook_notification.kind}\r\n#{webhook_notification.timestamp}\r\n"
    case webhook_notification.kind
    
    when 'disbursement'
    
      content += "disbursement_id: #{webhook_notification.disbursement.id}\r\namount: #{webhook_notification.disbursement.amount}\r\ndisbursement_date: #{webhook_notification.disbursement.disbursement_date}"
    
    when 'subscription_canceled', 'subscription_charged_successfully', 'subscription_charged_unsuccessfully', 'subscription_expired', 'subscription_trial_ended', 'subscription_went_active', 'subscription_went_past_due'

      user = User.find_by_braintree_subscription_id(webhook_notification.subscription.id)
      content += "user: #{user.email}\r\nsubscription_id: #{webhook_notification.subscription.id}"

    else

      content += "#{webhook_notification.inspect}"
      
    end

    NotifyViaSlack.delay.call(content: content)
    render nothing: true, status: 200
  end

  def sandbox_braintree_slack_pings
    # sample_notification = Braintree::WebhookTesting.sample_notification(
    #   Braintree::WebhookNotification::Kind::SubscriptionWentPastDue,
    #   "my_id"
    # )
    webhook_notification = Braintree::WebhookNotification.parse(
      request.params["bt_signature"],
      request.params["bt_payload"]
    )
    content = "Braintree | #{webhook_notification.kind}\r\n#{webhook_notification.timestamp}\r\n"
    case webhook_notification.kind
    
    when 'disbursement'
    
      content += "disbursement_id: #{webhook_notification.disbursement.id}\r\namount: #{webhook_notification.disbursement.amount}\r\ndisbursement_date: #{webhook_notification.disbursement.disbursement_date}"
    
    when 'subscription_canceled', 'subscription_charged_successfully', 'subscription_charged_unsuccessfully', 'subscription_expired', 'subscription_trial_ended', 'subscription_went_active', 'subscription_went_past_due'

      content += "subscription_id: #{webhook_notification.subscription.id}"

    else

      content += "#{webhook_notification.inspect}"

    end

    NotifyViaSlack.delay.call(content: content, channel: '#tengence-dev')
    render nothing: true, status: 200
  end

  private
    def deny_yet_to_subscribe_user
      if current_user.yet_to_subscribe?
        flash[:alert] = "You are not authorized to view this page."
        redirect_to :billing
      end
    end

    def deny_subscribed_user
      if current_user.subscribed?
        flash[:alert] = "You are not authorized to view this page."
        redirect_to :billing
      end
    end

    def deny_unsubscribed_user
      if current_user.unsubscribed?
        flash[:alert] = "You are not authorized to view this page."
        redirect_to :billing
      end
    end

end
