p 'start'
10000.times do |a|
  puts a
  Tender.create(
    ref_no: Faker::Company.ein,
    buyer_company_name: Faker::Company.name,
    buyer_contact_number: Faker::PhoneNumber.phone_number,
    buyer_name: Faker::Name.name,
    buyer_email: Faker::Internet.email,
    description: Faker::Lorem.sentences(5).join(" "),
    published_date: Faker::Date.between(7.days.ago, Date.today),
    closing_datetime: Faker::Time.between(DateTime.now - 7.days, DateTime.now + 7.days),
    external_link: Faker::Internet.url
  )
end
