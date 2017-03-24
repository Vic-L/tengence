require 'spec_helper'

feature 'trial_tenders', type: :feature, js: true do
  let(:tenders_page) { TendersPage.new }
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:yet_to_subscribe_user) { create(:user, :braintree) }

  feature 'during trial' do
    before :each do
      login_as(yet_to_subscribe_user, scope: :user)
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
        WatchedTender.create(user_id: yet_to_subscribe_user.id, tender_id: Tender.first.ref_no)
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
        WatchedTender.create(user_id: yet_to_subscribe_user.id, tender_id: Tender.first.ref_no)
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

    feature 'show tender page' do

      scenario "should be able to view the full details of a non inhouse tender" do
        tenders_page.seed_gebiz_tender
        tenders_page.visit_show_tender_page Tender.first.ref_no
        wait_for_page_load
        
        expect(page).to have_content 'Reference No'
        expect(page).to have_content 'Description'
        expect(page).to have_content 'Published Date'
        expect(page).to have_content 'Closing Date'
        expect(page).to have_content 'Closing Time'
        expect(page).to have_content 'Buyer Company Name'
        expect(page).to have_content 'Buyer Name'
        expect(page).to have_content 'Buyer Contact Number'
        expect(page).to have_content 'Original Link'
      end

      scenario "should be able to view the full details of a inhouse tender" do
        tenders_page.seed_inhouse_tender
        tenders_page.visit_show_tender_page Tender.first.ref_no
        wait_for_page_load
        
        expect(page).to have_content 'Reference No'
        expect(page).to have_content 'Description'
        expect(page).to have_content 'Published Date'
        expect(page).to have_content 'Closing Date'
        expect(page).to have_content 'Closing Time'
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

  feature 'after trial' do

    before :each do
      login_as(yet_to_subscribe_user, scope: :user)
      page.driver.browser.manage.window.resize_to(1432, 782)
    end

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
          expect(page).to have_content 'You have used up your credits for the month to unlock business leads.'
          expect(page).to have_link 'SUBSCRIBE now', href: '/billing'
        end
      end

      scenario 'cannot reveal details in another tab once hit limit' do
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

          tenders_page.in_browser(:one) do
            login_as(yet_to_subscribe_user, scope: :user)
            tenders_page.visit_current_tenders_page
            wait_for_page_load

            tenders_page.click_common '.more-button', 2
            expect(page).to have_selector '#view-more-modal'
            tenders_page.click_unique '#buy-details'
            tenders_page.click_common '.close-reveal-modal'
            expect(page).not_to have_selector '#view-more-modal'
          end

          tenders_page.click_common '.more-button', 3
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          expect(tenders_page.alert_text).to eq "You have used up all your credits for the month. Please come back next month."
          tenders_page.accept_confirm
          expect(page).to have_content 'You have used up your credits for the month to unlock business leads.'
          expect(page).to have_link 'SUBSCRIBE now', href: '/billing'
        end
      end

      scenario 'can reveal details of an already unlocked tender in another tab' do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_current_tenders_data
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          first_tender_description = tenders_page.find_css('tbody tr td')[0].all_text
          
          tenders_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'

          tenders_page.in_browser(:one) do
            login_as(yet_to_subscribe_user, scope: :user)
            tenders_page.visit_current_tenders_page
            wait_for_page_load

            tenders_page.click_common '.more-button'
            expect(page).to have_selector '#view-more-modal'
            tenders_page.click_unique '#buy-details'
            tenders_page.click_common '.close-reveal-modal'
            expect(page).not_to have_selector '#view-more-modal'
          end

          expect(page).not_to have_content 'Buyer Company Name'
          expect(page).not_to have_content 'Buyer Name'
          expect(page).not_to have_content 'Buyer Contact Number'

          tenders_page.click_unique '#buy-details'

          tenders_page.click_common '.more-button', 3
          expect(page).to have_selector '#view-more-modal'
          tenders_page.click_unique '#buy-details'
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
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
          expect(page).to have_content 'You have used up your credits for the month to unlock business leads.'
          expect(page).to have_link 'SUBSCRIBE now', href: '/billing'
        end
      end

    end

    feature 'show tender page' do

      scenario "user's trial_tenders_count should increase" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_gebiz_tender
          tenders_page.visit_show_tender_page Tender.first.ref_no
          wait_for_page_load

          expect(yet_to_subscribe_user.trial_tenders_count).to eq 0

          tenders_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(yet_to_subscribe_user.reload.trial_tenders_count).to eq 1
        end
      end

      scenario "trial_tenders should have the correct tender and user info" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_gebiz_tender
          WatchedTender.create(tender_id: Tender.first.ref_no, user_id: yet_to_subscribe_user.id)
          tenders_page.visit_show_tender_page Tender.first.ref_no
          wait_for_page_load
          
          tenders_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(TrialTender.count).to eq 1
          expect(TrialTender.first.user_id).to eq yet_to_subscribe_user.id
          expect(TrialTender.first.tender_id).to eq Tender.first.ref_no
        end
      end

      scenario "should be able to view the full details of a non inhouse tender once unlocked" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_gebiz_tender
          tenders_page.visit_show_tender_page Tender.first.ref_no
          wait_for_page_load
          
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
          tenders_page.visit_show_tender_page Tender.first.ref_no
          wait_for_page_load
          
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
          tenders_page.visit_show_tender_page Tender.first.ref_no
          wait_for_page_load

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

          tenders_page.visit_show_tender_page Tender.first.ref_no
          wait_for_page_load

          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).to have_content 'Original Link'
        end
      end

      scenario "should be able to view the full details of a inhouse tender for the whole day" do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_inhouse_tender
          tenders_page.visit_show_tender_page Tender.first.ref_no
          wait_for_page_load

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

          tenders_page.visit_show_tender_page Tender.first.ref_no
          wait_for_page_load

          expect(page).not_to have_content 'Buyer Company Name'
          expect(page).not_to have_content 'Buyer Name'
          expect(page).not_to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'
          expect(page).not_to have_selector '#buy-details'

          tenders_page.click_unique '#ga-tender-inhouse-more'
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'
        end
      end

      scenario 'cannot reveal details once hit limit' do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_current_tenders_data
          tenders_page.visit_current_tenders_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          first_tender_description = tenders_page.find_css('tbody tr td')[0].all_text
          
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
          tenders_page.click_unique '#buy-details'
          tenders_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'

          tenders_page.visit_show_tender_page Tender.find_by_description(first_tender_description).ref_no
          expect(page).to have_content 'You have used up your credits for the month to unlock business leads.'
          expect(page).to have_link 'SUBSCRIBE now', href: '/billing'
        end
      end

      scenario 'can reveal details of an already unlocked tender in another tab' do
        Timecop.freeze(Date.today + 2.months) do
          tenders_page.seed_current_tenders_data
          tenders_page.visit_show_tender_page Tender.first.ref_no
          wait_for_page_load

          expect(page).not_to have_content 'Buyer Company Name'
          expect(page).not_to have_content 'Buyer Name'
          expect(page).not_to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'

          tenders_page.in_browser(:one) do
            login_as(yet_to_subscribe_user, scope: :user)
            tenders_page.visit_show_tender_page Tender.first.ref_no
            wait_for_page_load

            tenders_page.click_unique '#buy-details'
            wait_for_ajax

            expect(page).to have_content 'Buyer Company Name'
          end

          tenders_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).to have_content 'Original Link'
        end
      end

    end

  end

  feature 'chosen user' do

    let!(:chosen_user) { create(:user, :braintree, email: ENV['CHOSEN_USERS_EMAIL'].split(',').first) }
   
    before :each do
      tenders_page.seed_current_tenders_data
      login_as(chosen_user, scope: :user)
      page.driver.browser.manage.window.resize_to(1432, 782)
    end

    # feature 'during trial' do

    #   scenario 'should be not redirected to plans page' do
    #     tenders_page.visit_current_tenders_page
    #     expect(page.current_path).not_to eq plans_path

    #     tenders_page.visit_watched_tenders_page
    #     expect(page.current_path).not_to eq plans_path

    #     tenders_page.visit_show_tender_page Tender.first.ref_no
    #     expect(page.current_path).not_to eq plans_path
    #   end

    # end

    feature 'after trial' do

      # scenario 'should be redirected to plans page' do
      #   Timecop.freeze(Date.today + 2.months) do
      #     tenders_page.visit_current_tenders_page
      #     expect(page.current_path).to eq plans_path

      #     tenders_page.visit_watched_tenders_page
      #     expect(page.current_path).to eq plans_path

      #     tenders_page.visit_show_tender_page Tender.first.ref_no
      #     expect(page.current_path).to eq plans_path
      #   end
      # end

      # scenario 'should be not be redirected to plans page once signed up' do
      #   Timecop.freeze(Date.today + 2.months) do
      #     brain_tree_page.visit_subscribe_one_month_page
      #     expect(page).to have_selector 'iframe'
      #     page.within_frame 'braintree-dropin-frame' do
      #       fill_in 'credit-card-number', with: brain_tree_page.valid_visa
      #       fill_in 'expiration', with: (Time.current + 2.years).strftime('%m%y')
      #       fill_in 'cvv', with: brain_tree_page.valid_cvv
      #     end
      #     brain_tree_page.scroll_into_view '#submit'
      #     brain_tree_page.click_unique '#submit'
      #     wait_for_page_load

      #     expect(page).to have_content "Congratulations, you have successfully subscribed to Tengence. Welcome to the community!\nAn invoice of this transaction will be sent to your registered email shortly."

      #     tenders_page.visit_current_tenders_page
      #     expect(page.current_path).not_to eq plans_path

      #     tenders_page.visit_watched_tenders_page
      #     expect(page.current_path).not_to eq plans_path

      #     tenders_page.visit_show_tender_page Tender.first.ref_no
      #     expect(page.current_path).not_to eq plans_path
      #   end

      # end

    end

  end

end