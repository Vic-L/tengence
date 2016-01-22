class PostTenderPage
  include Capybara::DSL
  
  def visit_page
    visit '/tenders/new'
    self
  end

  def press_create_tender_button
    find_css('#submit').first.click
  end

  def find_css selector
    page.driver.find_css selector
  end

  def fill_up_form
    fill_in 'tender_description', with: Faker::Lorem.sentences(5).join(" ")
    fill_in 'tender_buyer_name', with: Faker::Name.name
    fill_in 'tender_buyer_email', with: Faker::Internet.email
    fill_in 'tender_buyer_contact_number', with: "90909090"
    fill_in 'tender_closing_datetime', with: (Time.now + 1.month).strftime('%Y-%m-%d %H:%M')
    fill_in 'tender_long_description', with: Faker::Lorem.sentences(10).join("\r\n")
  end
end
