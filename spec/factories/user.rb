FactoryGirl.define do
  factory :user do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    email {Faker::Internet.email}
    password "password"
    confirmed_at Time.current - 2.days
    keywords 'stub'

    after :build do |user|
      user.class.skip_callback :create, :after, :register_braintree_customer
      user.class.skip_callback :destroy, :before, :delete_braintree_customer
    end
  end

  trait :read_only do
    access_level 'read_only'
  end

  trait :write_only do
    access_level 'write_only'
  end

  trait :unconfirmed do
    confirmed_at nil
    confirmation_sent_at nil
  end

  trait :without_keywords do
    keywords nil
  end

  trait :pending_reconfirmation do
    unconfirmed_email {Faker::Internet.email}
  end

  trait :braintree do
    after :create do |user|
      user.register_braintree_customer
      CreateBraintreeCustomerWorker.drain
    end
  end

  trait :subscribed do
    # has braintree_subscription_id
    # dont have next_billing_date
    after :create do |user|
      result = Braintree::Customer.create(
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        company: user.company_name
      )
      user.braintree_customer_id = result.customer.id
      result = Braintree::PaymentMethod.create(
        customer_id: user.braintree_customer_id,
        payment_method_nonce: 'fake-valid-nonce',
        options: {
          verify_card: true,
          make_default: true
        }
      )
      user.default_payment_method_token = result.payment_method.token
      result = Braintree::Subscription.create(
        :payment_method_token => result.payment_method.token,
        :plan_id => "standard_plan",
        # :merchant_account_id => "gbp_account"
      )
      user.braintree_subscription_id = result.subscription.id
    end
  end

  trait :unsubscribed do
    # has braintree_subscription_id
    # has next_billing_date
    # next_billing_date is past
    after :create do |user|
      result = Braintree::Customer.create(
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        company: user.company_name
      )
      user.braintree_customer_id = result.customer.id
      result = Braintree::PaymentMethod.create(
        customer_id: user.braintree_customer_id,
        payment_method_nonce: 'fake-valid-nonce',
        options: {
          verify_card: true,
          make_default: true
        }
      )
      user.default_payment_method_token = result.payment_method.token
      result = Braintree::Subscription.create(
        :payment_method_token => result.payment_method.token,
        :plan_id => "standard_plan",
        # :merchant_account_id => "gbp_account"
      )
      user.braintree_subscription_id = result.subscription.id
      user.next_billing_date = result.subscription.next_billing_date
      Braintree::Subscription.cancel(result.subscription.id)
    end
  end
end
