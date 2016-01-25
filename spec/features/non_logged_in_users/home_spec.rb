require 'spec_helper'

feature "home_page", type: :feature, js: true do
  let(:home_page) { HomePage.new }

  before :each do
    home_page.visit_page
    page.driver.browser.manage.window.resize_to(1432, 782)
    wait_for_ajax
    wait_for_page_load
  end

  feature 'demo email' do
    scenario 'invalid fields' do
      home_page.submit_demo_email_request
      expect(page).to have_content 'Please enter your email'
      expect(page).to have_content 'Please acknowledge this checkbox'
    end

    scenario 'valid fields' do
      expect(ActionMailer::Base.deliveries.count).to eq 0
      home_page.fill_up_demo_email_form
      home_page.submit_demo_email_request
      expect {home_page.submit_demo_email_request}.to change( Sidekiq::Worker.jobs, :size ).by(1)
    end

    scenario 'invalid email' do
      home_page.fill_up_demo_email_form
      fill_in 'demo_email', with: Faker::Lorem.word
      home_page.submit_demo_email_request
      expect(page).to have_content 'Please enter a valid email'
      expect(page).not_to have_content 'Please acknowledge this checkbox'
    end
  end
end