FactoryGirl.define do
  factory :user do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    email {Faker::Internet.email}
    password "password"
    confirmed_at Time.current - 2.days
    keywords 'stub'

    after :build do |user|
      user.class.skip_callback :validation, :before, :create_braintree_customer
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
  end

  trait :without_keywords do
    keywords nil
  end

  trait :pending_reconfirmation do
    unconfirmed_email {Faker::Internet.email}
  end
end
