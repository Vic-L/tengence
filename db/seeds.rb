p 'seeding'
p 'create current tenders'
102.times do |a|
  if a%3 == 0
    puts 'create gebiz tender'
    Tender.create(
      ref_no: Faker::Company.ein,
      buyer_company_name: Faker::Company.name,
      buyer_contact_number: Faker::PhoneNumber.phone_number,
      buyer_name: Faker::Name.name,
      buyer_email: Faker::Internet.email,
      description: Faker::Lorem.sentences(5).join(" "),
      published_date: Faker::Date.between(7.days.ago, Date.today),
      closing_datetime: Faker::Time.between(DateTime.now + 7.days, DateTime.now + 14.days),
      external_link: 'gebiz.gov'
    )
  elsif a%3 == 1
    puts 'create non gebiz tender'
    # this will fail validation
    tender = Tender.new(
      ref_no: Faker::Company.ein,
      buyer_company_name: Faker::Company.name,
      # buyer_contact_number: Faker::PhoneNumber.phone_number,
      # buyer_name: Faker::Name.name,
      # buyer_email: Faker::Internet.email,
      description: Faker::Lorem.sentences(5).join(" "),
      published_date: Faker::Date.between(7.days.ago, Date.today),
      closing_datetime: Faker::Time.between(DateTime.now + 7.days, DateTime.now + 14.days),
      external_link: Faker::Internet.url
    )
    tender.save(validate: false)
  elsif a%3 == 2
    puts 'create inhouse tender'
    Tender.create(
      ref_no: 'InHouse-' + (Time.now.to_f*1000).to_i.to_s,
      buyer_company_name: Faker::Company.name,
      buyer_contact_number: Faker::PhoneNumber.phone_number,
      buyer_name: Faker::Name.name,
      buyer_email: Faker::Internet.email,
      description: Faker::Lorem.sentences(5).join(" "),
      long_description: Faker::Lorem.sentences(10).join("\r\n"),
      published_date: Faker::Date.between(7.days.ago, Date.today),
      closing_datetime: Faker::Time.between(DateTime.now + 7.days, DateTime.now + 14.days)
    )
  end
end
p 'seeding ended'
# p "Create vljc17@gmail.com User"
# User.create(email: "vljc17@gmail.com", company_name: "qweqwe", first_name: "qwe", last_name: "qwe", password: "qweqweqwe")