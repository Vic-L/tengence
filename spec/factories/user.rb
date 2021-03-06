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

  trait :auto_renew do
    auto_renew true
  end

  trait :braintree do
    after :create do |user|
      user.register_braintree_customer
      CreateBraintreeCustomerWorker.drain
    end
  end

  trait :subscribed_one_month do
    # has braintree_subscription_id
    # dont have next_billing_date
    before :create do |user|
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
      user.next_billing_date = Date.today + 30.day
      user.subscribed_plan = "one_month_plan"
    end
  end

  trait :subscribed_three_months do
    # has braintree_subscription_id
    # dont have next_billing_date
    before :create do |user|
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
      user.next_billing_date = Date.today + 90.day
      user.subscribed_plan = "three_months_plan"
    end
  end

  trait :subscribed_one_year do
    # has braintree_subscription_id
    # dont have next_billing_date
    before :create do |user|
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
      user.next_billing_date = Date.today + 1.year
      user.subscribed_plan = "one_year_plan"
    end
  end

  trait :unsubscribed_one_month do
    # has braintree_subscription_id
    # has next_billing_date
    # next_billing_date is past
    before :create do |user|
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
      user.next_billing_date = Date.today + 30.day
      user.subscribed_plan = "free_plan"
    end
  end

  trait :transacted_one_month do
    after :create do| user|
      result = Braintree::Transaction.sale(
        :payment_method_token => user.default_payment_method_token,
        amount: "59.00",
        :options => {
          :submit_for_settlement => true
        }
      )
    end
  end
end
