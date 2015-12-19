FactoryGirl.define do
  factory :user do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    email {Faker::Internet.email}
    password "password"
  end

  trait :read_only do
    access_level 'read_only'
  end

  trait :write_only do
    access_level 'write_only'
  end
end
