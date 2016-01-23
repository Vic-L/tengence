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
    # fill up  closing date time without triggering disabled field on focus
    page.execute_script("var now = new Date();now.setDate(now.getDate()+30);$('#tender_closing_datetime').val(strftime('%Y-%m-%d %H:%M', now))")
    fill_in 'tender_long_description', with: Faker::Lorem.sentences(10).join("\r\n")
  end

  def upload_file id,file_path
    attach_file id, file_path
  end

  def upload_2_files_then_remove_first
    id = find_css('fieldset').first.find_css("input[type='file']").first['id']
    attach_file id, "#{Rails.root}/Gemfile"

    find('a.add-upload').click

    id = find_css('fieldset').last.find_css("input[type='file']").first['id']
    attach_file id, "#{Rails.root}/Capfile"
    
    find_css('.remove-upload').first.click
  end

  def upload_2_files
    id = find_css('fieldset').first.find_css("input[type='file']").first['id']
    attach_file id, "#{Rails.root}/Gemfile"

    find('a.add-upload').click

    id = find_css('fieldset').last.find_css("input[type='file']").first['id']
    attach_file id, "#{Rails.root}/Capfile"
  end

  def upload_blank_file
    find('a.add-upload').click
  end
end