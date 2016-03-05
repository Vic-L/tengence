class BrainTreeController < ApplicationController
  before_action :authenticate_user!, except: [:sandbox_braintree_slack_pings, :braintree_slack_pings]
  before_action :deny_unconfirmed_users, except: [:sandbox_braintree_slack_pings, :braintree_slack_pings]
  before_action :deny_write_only_access, except: [:sandbox_braintree_slack_pings, :braintree_slack_pings]
  before_action :deny_subscribed_user, only: [:subscribe, :create_payment]
  before_action :deny_unresubscribable_user, only: [:subscribe, :change_payment, :create_payment, :unsubscribe]
  before_action :deny_resubscribable_user, only: [:change_payment, :unsubscribe]
  before_action :deny_yet_to_subscribe_user, only: [:change_payment, :payment_history, :update_payment]
  skip_before_action :verify_authenticity_token, only: [:sandbox_braintree_slack_pings, :braintree_slack_pings]

  def billing
    if current_user.braintree_subscription_id


      @payment_method_token = current_user.braintree_subscription.payment_method_token
      @payment_method = Braintree::PaymentMethod.find(@payment_method_token) unless @payment_method_token.nil?
    end
  end

  def subscribe
    @plan = params[:plan]
    @client_token = Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
  end

  def change_payment
    @client_token = Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
    @payment_method = current_user.braintree_subscription.payment_method_token
  end

  def payment_history
    @subscription = Braintree::Subscription.find(current_user.braintree_subscription_id)
  end

  def update_payment

    resp = CreateNewPaymentMethod.call(
      braintree_customer_id: current_user.braintree_customer_id,
      payment_method_nonce: params[:payment_method_nonce])

    if resp[:status] == 'success'

      resp = UpdateSubscriptionWithNewPaymentMethod.call(
        braintree_subscription_id: current_user.braintree_subscription_id,
        payment_method_token: resp[:token],
        user: current_user)

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

      # binding.pry

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
        plan: params[:plan]
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

      # binding.pry

    end

  end

  def unsubscribe
    resp = UnsubscribeFromTengence.call(user: current_user)
    eval(resp)
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

    when 'transaction_disbursed'

      content += "transaction_id: #{webhook_notification.transaction.id}\r\namount: #{webhook_notification.transaction.amount}\r\ntransaction_status: #{webhook_notification.transaction.status}\r\ntransaction_date: #{webhook_notification.transaction.created_at}\r\customer_email: #{webhook_notification.transaction.customer_details.email}"
    
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

    when 'transaction_disbursed'

      content += "transaction_id: #{webhook_notification.transaction.id}\r\namount: #{webhook_notification.transaction.amount}\r\ntransaction_status: #{webhook_notification.transaction.status}\r\ntransaction_date: #{webhook_notification.transaction.created_at}\r\customer_email: #{webhook_notification.transaction.customer_details.email}"
    
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

    def deny_unresubscribable_user
      if current_user.cannot_resubscribe?
        flash[:alert] = "You are not authorized to view this page."
        redirect_to :billing
      end
    end

    def deny_resubscribable_user
      if current_user.can_resubscribe?
        flash[:alert] = "You are not authorized to view this page."
        redirect_to :billing
      end
    end

end
