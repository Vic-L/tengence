require 'spec_helper'

feature "home_page", type: :feature, js: true do
  let(:home_page) { HomePage.new }

  before :each do
    home_page.visit_page
    page.driver.browser.manage.window.resize_to(1432, 782)
    wait_for_ajax
    wait_for_page_load
  end

  feature 'sources and counting' do

    scenario 'list of sources should expand on click' do
      home_page.scroll_into_view '#show-all'
      initial_height = page.evaluate_script("$('#sources-and-counting ul')[0].clientHeight")
      home_page.click_unique '#show-all'
      sleep 1
      new_height = page.evaluate_script("$('#sources-and-counting ul')[0].clientHeight")
      expect(new_height > initial_height).to eq true
    end
  end

  feature 'demo email' do

    scenario 'invalid fields' do
      home_page.click_common '.email-demo-submit-button'
      expect(page).to have_content 'Please enter your email'
      expect(page).to have_content 'Please acknowledge this checkbox'
    end

    scenario 'valid fields' do
      expect(Sidekiq::Worker.jobs.size).to eq 0
      home_page.fill_up_demo_email_form
      home_page.click_common '.email-demo-submit-button'
      expect {home_page.click_common '.email-demo-submit-button'}.to change( Sidekiq::Worker.jobs, :size ).by(2)
      # 1 is slack ping
    end

    scenario 'invalid email' do
      home_page.fill_up_demo_email_form
      fill_in 'demo_email', with: Faker::Lorem.word
      home_page.click_common '.email-demo-submit-button'
      expect(page).to have_content 'Please enter a valid email'
      expect(page).not_to have_content 'Please acknowledge this checkbox'
    end

  end

  feature 'contacts' do

    scenario 'invalid fields' do
      home_page.submit_contacts_form
      expect(page).to have_content 'Please fill up all fields.'
    end

    scenario 'invalid email' do
      home_page.fill_up_contacts_form
      fill_in 'contact_email', with: Faker::Lorem.word
      # TODO validate base on html5 validation of email field
      expect(Sidekiq::Worker.jobs.size).to eq 0
      home_page.submit_contacts_form
      expect(Sidekiq::Worker.jobs.size).to eq 0
    end

    scenario 'valid fields' do
      expect(Sidekiq::Worker.jobs.size).to eq 0
      home_page.fill_up_contacts_form
      home_page.submit_contacts_form
      wait_for_ajax

      expect(Sidekiq::Worker.jobs.size).to eq 2
      # 1 is slack ping
      expect(page).not_to have_content 'Please fill up all fields.'
      expect(page).to have_content 'Email Sent Successfully.'
      expect(page).to have_content 'your message has been submitted to us.'
      expect(page).to have_content 'The Tengence team will contact you shortly.'
    end

  end

end