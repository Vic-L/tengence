class CurrentTendersPage
  include TendersPageFunctions

  def visit_page
    visit '/current_tenders'
    self
  end

  def seed_data
    102.times do |a|
      if a%2 == 0
        Tender.create(
          ref_no: Faker::Company.ein,
          buyer_company_name: Faker::Company.name,
          buyer_contact_number: Faker::PhoneNumber.phone_number,
          buyer_name: Faker::Name.name,
          buyer_email: Faker::Internet.email,
          description: Faker::Lorem.sentences(5).join(" "),
          published_date: Faker::Date.between(7.days.ago, Time.now.in_time_zone('Singapore').to_date),
          closing_datetime: Faker::Time.between(DateTime.now + 7.days, DateTime.now + 21.days),
          external_link: 'gebiz.gov'
        )
      elsif a%2 == 1
        # this will fail validation
        tender = Tender.new(
          ref_no: Faker::Company.ein,
          buyer_company_name: Faker::Company.name,
          # buyer_contact_number: Faker::PhoneNumber.phone_number,
          # buyer_name: Faker::Name.name,
          # buyer_email: Faker::Internet.email,
          description: Faker::Lorem.sentences(5).join(" "),
          published_date: Faker::Date.between(7.days.ago, Time.now.in_time_zone('Singapore').to_date),
          closing_datetime: Faker::Time.between(DateTime.now + 7.days, DateTime.now + 21.days),
          external_link: Faker::Internet.url
        )
        tender.save(validate: false)
      end
    end
  end

end