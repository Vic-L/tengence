module TendersPageFunctions
  include Capybara::DSL

  def in_browser(name)
    old_session = Capybara.session_name

    Capybara.session_name = name
    yield

    Capybara.session_name = old_session
  end

  def alert_text
    page.driver.browser.switch_to.alert.text
  end

  def accept_confirm
    page.driver.browser.switch_to.alert.accept
  end

  def reject_confirm
    page.driver.browser.switch_to.alert.dismiss
  end

  def find_css selector
    page.driver.find_css selector
  end

  def sort_by_newest
    find_css('select.sort').first.find_xpath('option').first.click
  end

  def sort_by_expiring
    find_css('select.sort').first.find_xpath('option').last.click
  end

  def get_first_published_date
    find_css('tbody tr td')[1].all_text
  end

  def get_first_closing_date_time
    (find_css('tbody tr td')[2].all_text + " " + find_css('tbody tr td')[3].all_text)
  end

  def scroll_into_view selector
    eval("execute_script(\"$('#{selector}')[0].scrollIntoView(false);\")")
    sleep 1
  end

  def click_common selector, counter=0
    if counter.zero?
      eval("execute_script(\"$('#{selector}')[0].scrollIntoView(false);\")")
      eval("execute_script(\"$('#{selector}')[0].click();\")")
      sleep 1
    else
      eval("execute_script(\"$('#{selector}').slice(#{counter},#{counter+1})[0].scrollIntoView(false);\")")
      eval("execute_script(\"$('#{selector}').slice(#{counter},#{counter+1})[0].click();\")")
      sleep 1
    end
  end

  def click_unique selector
    find(selector).click
  end

  def get_last_closing_date_time
    (find_css('tbody tr:last-child td')[2].all_text  + " " + find_css('tbody tr:last-child td')[3].all_text)
  end

  def get_last_published_date
    find_css('tbody tr:last-child td')[1].all_text
  end

  def get_all_descriptions
    array = []
    find_css('tbody tr').each do |tr|
      array << tr.find_css('td')[0].all_text
    end
    array
  end

  def get_first_tender_details
    tender = {}
    tender['description'] = find_css('tbody tr td')[0].all_text
    tender['published_date'] = get_first_published_date
    tender['closing_date'] = find_css('tbody tr td')[2].all_text
    tender['closing_time'] = find_css('tbody tr td')[3].all_text
    tender
  end

  def get_view_more_modal_content
    find_css('#view-more-modal').first.all_text
  end

  def fill_up_tender_form
    fill_in 'tender_description', with: Faker::Lorem.sentences(5).join(" ")
    fill_in 'tender_buyer_name', with: Faker::Name.name
    fill_in 'tender_buyer_email', with: Faker::Internet.email
    fill_in 'tender_buyer_contact_number', with: "90909090"
    # fill up  closing date time without triggering disabled field on focus
    page.execute_script("var now = new Date();now.setDate(now.getDate()+30);$('#tender_closing_datetime').val(strftime('%Y-%m-%d %H:%M', now))")
    fill_in 'tender_long_description', with: Faker::Lorem.sentences(10).join("\r\n")
  end

  def seed_gebiz_tender
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
  end

  def seed_non_gebiz_tender
    Tender.create(
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
  end

  def seed_inhouse_tender
    Tender.create(
      ref_no: 'InHouse-' + Faker::Company.ein,
      buyer_company_name: Faker::Company.name,
      buyer_contact_number: Faker::PhoneNumber.phone_number,
      buyer_name: Faker::Name.name,
      buyer_email: Faker::Internet.email,
      description: Faker::Lorem.sentences(5).join(" "),
      long_description: Faker::Lorem.sentences(5).join(" "),
      published_date: Faker::Date.between(7.days.ago, Time.now.in_time_zone('Singapore').to_date),
      closing_datetime: Faker::Time.between(DateTime.now + 7.days, DateTime.now + 21.days)
    )
  end

  def seed_current_tenders_data
    102.times do |a|
      if a%2 == 0
        seed_gebiz_tender
      elsif a%2 == 1
        seed_non_gebiz_tender
      end
    end
  end
end