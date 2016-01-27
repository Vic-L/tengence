FactoryGirl.define do
  factory :tender do
    ref_no {Faker::Company.ein}
    buyer_company_name {Faker::Company.name}
    buyer_name {Faker::Name.name}
    buyer_contact_number {Faker::PhoneNumber.phone_number}
    buyer_email {Faker::Internet.email}
    description {Faker::Lorem.sentences(5).join(" ")}
    published_date {Faker::Date.between(2.days.ago, Time.now.in_time_zone('Singapore').to_date)}
    closing_datetime {Faker::Time.between(Time.current, Time.current + 1.month)}

    trait :gebiz do
      external_link "gebiz.gov"
    end

    trait :non_gebiz do
      external_link {Faker::Internet.url}
    end

    trait :inhouse do
      external_link 'InHouse'
    end

    trait :current do
      published_date {Faker::Date.between(2.days.ago, Time.now.in_time_zone('Singapore').to_date)}
      closing_datetime {Faker::Time.between(Time.current, Time.current + 1.month)}
    end

    factory :gebiz_tender, traits: [:gebiz]
    factory :non_gebiz_tender, traits: [:non_gebiz]
  end
end