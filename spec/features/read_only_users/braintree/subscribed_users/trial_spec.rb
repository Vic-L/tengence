require 'spec_helper'

feature 'trial_tenders', type: :feature, js: true do
  let(:tenders_page) { TendersPage.new }
  let!(:subscribed_user) { create(:user, :subscribed) }

  before :each do
    login_as(subscribed_user, scope: :user)
    page.driver.browser.manage.window.resize_to(1432, 782)
  end

  feature 'current_tenders page' do

    scenario "should be able to view the full details of a non inhouse tender" do
      tenders_page.seed_gebiz_tender
      tenders_page.visit_current_tenders_page
      wait_for_page_load
      tenders_page.click_common '.more-button'
      
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_selector '#buy-details'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).to have_content 'Original Link'
      tenders_page.click_common '.close-reveal-modal'
      expect(page).not_to have_selector '#view-more-modal'

      tenders_page.click_common '.more-button'
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_selector '#buy-details'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).to have_content 'Original Link'
    end

    scenario "should be able to view the full details of a inhouse tender" do
      tenders_page.seed_inhouse_tender
      tenders_page.visit_current_tenders_page
      wait_for_page_load
      
      tenders_page.click_common '.more-button'
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_content 'Buyer Company Name'
      expect(page).not_to have_content 'Buyer Name'
      expect(page).not_to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
      tenders_page.click_unique '#ga-tender-inhouse-more'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
      tenders_page.click_common '.close-reveal-modal'
      expect(page).not_to have_selector '#view-more-modal'

      tenders_page.click_common '.more-button'
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_content 'Buyer Company Name'
      expect(page).not_to have_content 'Buyer Name'
      expect(page).not_to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
      tenders_page.click_unique '#ga-tender-inhouse-more'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
    end

  end

  feature 'watched_tenders page' do

    scenario "should be able to view the full details of a non inhouse tender" do
      tenders_page.seed_gebiz_tender
      WatchedTender.create(user_id: subscribed_user.id, tender_id: Tender.first.ref_no)
      tenders_page.visit_watched_tenders_page
      wait_for_page_load
      tenders_page.click_common '.more-button'
      
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_selector '#buy-details'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).to have_content 'Original Link'
      tenders_page.click_common '.close-reveal-modal'
      expect(page).not_to have_selector '#view-more-modal'

      tenders_page.click_common '.more-button'
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_selector '#buy-details'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).to have_content 'Original Link'
    end

    scenario "should be able to view the full details of a inhouse tender" do
      tenders_page.seed_inhouse_tender
      WatchedTender.create(user_id: subscribed_user.id, tender_id: Tender.first.ref_no)
      tenders_page.visit_watched_tenders_page
      wait_for_page_load
      
      tenders_page.click_common '.more-button'
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_content 'Buyer Company Name'
      expect(page).not_to have_content 'Buyer Name'
      expect(page).not_to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
      tenders_page.click_unique '#ga-tender-inhouse-more'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
      tenders_page.click_common '.close-reveal-modal'
      expect(page).not_to have_selector '#view-more-modal'

      tenders_page.click_common '.more-button'
      expect(page).to have_selector '#view-more-modal'
      expect(page).not_to have_content 'Buyer Company Name'
      expect(page).not_to have_content 'Buyer Name'
      expect(page).not_to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
      tenders_page.click_unique '#ga-tender-inhouse-more'
      expect(page).to have_content 'Buyer Company Name'
      expect(page).to have_content 'Buyer Name'
      expect(page).to have_content 'Buyer Contact Number'
      expect(page).not_to have_content 'Original Link'
    end

  end

end
