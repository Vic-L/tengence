require 'spec_helper'

feature 'trial_tenders', type: :feature, js: true do
  let(:tenders_page) { TendersPage.new }
  let!(:yet_to_subscribe_user) { create(:user, :braintree) }

  before :each do
    login_as(yet_to_subscribe_user, scope: :user)
    page.driver.browser.manage.window.resize_to(1432, 782)
  end

  feature 'after trial' do

    feature 'current_tenders page' do

      scenario "user's trial_tenders_count should increase" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_gebiz_tender
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          expect(yet_to_subscribe_user.trial_tenders_count).to eq 0
          tenders_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(yet_to_subscribe_user.reload.trial_tenders_count).to eq 1
        end
      end

      scenario "trial_tenders should have the correct tender and user info" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_gebiz_tender
          WatchedTender.create(tender_id: Tender.first.ref_no, user_id: yet_to_subscribe_user.id)
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          first_tender_description = tenders_page.find_css('tbody tr td')[0].all_text
          tenders_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(TrialTender.count).to eq 1
          expect(TrialTender.first.user_id).to eq yet_to_subscribe_user.id
          expect(Tender.find(TrialTender.first.tender_id)).to eq Tender.find_by_description(first_tender_description)
        end
      end

      scenario "should be able to view the full details of a non inhouse tender once unlocked" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_gebiz_tender
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          tenders_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          expect(page).not_to have_content 'Buyer Company Name'
          expect(page).not_to have_content 'Buyer Name'
          expect(page).not_to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'
          tenders_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).to have_content 'Original Link'
        end
      end

      scenario "should be able to view the full details of a inhouse tender once unlocked" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_inhouse_tender
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          tenders_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          expect(page).not_to have_content 'Buyer Company Name'
          expect(page).not_to have_content 'Buyer Name'
          expect(page).not_to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'
          tenders_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'
        end
      end

      scenario "should be able to view the full details of a non inhouse tender for the whole day" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_gebiz_tender
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          
          tenders_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          tenders_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          
          tenders_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).to have_content 'Original Link'
        end
      end

      scenario "should be able to view the full details of a inhouse tender for the whole day" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_inhouse_tender
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          
          tenders_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          tenders_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          
          tenders_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#ga-tender-inhouse-more'
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
        end
      end

      scenario 'cannot reveal details once hit limit' do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_current_tenders_data
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          first_tender_description = tenders_page.find_css('tbody tr td')[0].all_text
          
          tenders_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          tenders_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          tenders_page.click_common '.more-button', 1
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          tenders_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          tenders_page.click_common '.more-button', 2
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          tenders_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'

          tenders_page.click_common '.more-button', 3
          expect(page).to have_selector '#view-more-modal'
          expect(page).to have_content 'You have used up your credits for the day to unlock business leads.'
          expect(page).to have_link 'SUBSCRIBE now', href: '/subscribe'
        end
      end

    end

    feature 'watched_tenders page' do

      scenario "user's trial_tenders_count should increase" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_gebiz_tender
          WatchedTender.create(user_id: yet_to_subscribe_user.id, tender_id: Tender.first.ref_no)
          tenders_page.visit_watched_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          expect(yet_to_subscribe_user.trial_tenders_count).to eq 0
          tenders_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(yet_to_subscribe_user.reload.trial_tenders_count).to eq 1
        end
      end

      scenario "trial_tenders should have the correct tender and user info" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_gebiz_tender
          WatchedTender.create(user_id: yet_to_subscribe_user.id, tender_id: Tender.first.ref_no)
          tenders_page.visit_watched_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          tenders_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(TrialTender.count).to eq 1
          expect(TrialTender.first.user_id).to eq yet_to_subscribe_user.id
          expect(Tender.find(TrialTender.first.tender_id)).to eq Tender.first
        end
      end

      scenario "should be able to view the full details of a non inhouse tender once unlocked" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_gebiz_tender
          WatchedTender.create(user_id: yet_to_subscribe_user.id, tender_id: Tender.first.ref_no)
          tenders_page.visit_watched_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          tenders_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          expect(page).not_to have_content 'Buyer Company Name'
          expect(page).not_to have_content 'Buyer Name'
          expect(page).not_to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'
          tenders_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).to have_content 'Original Link'
        end
      end

      scenario "should be able to view the full details of a inhouse tender once unlocked" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_inhouse_tender
          WatchedTender.create(user_id: yet_to_subscribe_user.id, tender_id: Tender.first.ref_no)
          tenders_page.visit_watched_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          tenders_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          expect(page).not_to have_content 'Buyer Company Name'
          expect(page).not_to have_content 'Buyer Name'
          expect(page).not_to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'
          tenders_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'
        end
      end

      scenario "should be able to view the full details of a non inhouse tender for the whole day" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_gebiz_tender
          WatchedTender.create(user_id: yet_to_subscribe_user.id, tender_id: Tender.first.ref_no)
          tenders_page.visit_watched_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          
          tenders_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          tenders_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          
          tenders_page.visit_watched_tenders_page
          wait_for_page_load
          
          tenders_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).to have_content 'Original Link'
        end
      end

      scenario "should be able to view the full details of a inhouse tender for the whole day" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_inhouse_tender
          WatchedTender.create(user_id: yet_to_subscribe_user.id, tender_id: Tender.first.ref_no)
          tenders_page.visit_watched_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          
          tenders_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          tenders_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          
          tenders_page.visit_watched_tenders_page
          wait_for_page_load
          
          tenders_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#ga-tender-inhouse-more'
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
        end
      end

      scenario 'cannot reveal details once hit limit' do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_current_tenders_data
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          
          tenders_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          tenders_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          tenders_page.click_common '.more-button', 1
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          tenders_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          tenders_page.click_common '.more-button', 2
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          tenders_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          
          tenders_page.click_common '.watch-button'
          tenders_page.click_common '.watch-button', 1
          tenders_page.click_common '.watch-button', 2
          tenders_page.click_common '.watch-button', 3
          tenders_page.visit_watched_tenders_page
          wait_for_page_load

          tenders_page.click_common '.more-button', 3
          expect(page).to have_selector '#view-more-modal'
          expect(page).to have_content 'You have used up your credits for the day to unlock business leads.'
          expect(page).to have_link 'SUBSCRIBE now', href: '/subscribe'
        end
      end

    end

  end

end