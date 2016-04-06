FactoryGirl.define do
  factory :tender do
    ref_no {Faker::Company.ein + "-_.!~*'()" + Faker::Company.ein}
    buyer_company_name {Faker::Company.name}
    buyer_name {Faker::Name.name}
    buyer_contact_number '67757981' # {Faker::PhoneNumber.phone_number}
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
      ref_no {'InHouse-' + (Faker::Time.between(Time.current - 1.hours, Time.current).to_f*1000).to_i.to_s}
      external_link 'InHouse'
      long_description {Faker::Lorem.sentences(10).join("\r\n")}
    end

    trait :past do
      published_date {Faker::Date.between(14.days.ago, Time.now.in_time_zone('Singapore').to_date - 7.days)}
      closing_datetime {Faker::Time.between(Time.current - 6.days, Time.current - 1.days)}
    end

    factory :gebiz_tender, traits: [:gebiz]
    factory :non_gebiz_tender, traits: [:non_gebiz]
  end
end