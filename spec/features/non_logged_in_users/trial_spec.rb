require 'spec_helper'

feature 'trial_tenders', type: :feature, js: true do
  let(:home_page) { HomePage.new }

  before :each do
    page.driver.browser.manage.window.resize_to(1432, 782)
  end

  feature 'home page' do

    scenario "should be able to view the full details of a non inhouse tender" do
      home_page.seed_gebiz_tender
      home_page.visit_page
      wait_for_page_load
      home_page.click_common '.more-button'
      
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_selector '#buy-details'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).to have_content 'Original Link'
      home_page.click_common '.close-reveal-modal'
      expect(page).not_to have_selector '#view-more-modal'

      home_page.click_common '.more-button'
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_selector '#buy-details'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).to have_content 'Original Link'
    end

    scenario "should be able to view the full details of a inhouse tender" do
      home_page.seed_inhouse_tender
      home_page.visit_page
      wait_for_page_load
      
      home_page.click_common '.more-button'
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_content 'Buyer Company Name'
      expect(page).not_to have_content 'Buyer Name'
      expect(page).not_to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
      home_page.click_unique '#ga-tender-inhouse-more'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
      home_page.click_common '.close-reveal-modal'
      expect(page).not_to have_selector '#view-more-modal'

      home_page.click_common '.more-button'
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_content 'Buyer Company Name'
      expect(page).not_to have_content 'Buyer Name'
      expect(page).not_to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
      home_page.click_unique '#ga-tender-inhouse-more'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
    end

  end

end
