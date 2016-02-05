require 'spec_helper'

feature 'trial_tenders', type: :feature, js: true do
  let(:current_tender_page) { CurrentTendersPage.new }
  let!(:yet_to_subscribe_user) { create(:user, :braintree) }

  before :each do
    login_as(yet_to_subscribe_user, scope: :user)
    page.driver.browser.manage.window.resize_to(1432, 782)
  end

  feature 'after trial' do

    feature 'current_tenders page' do

      scenario "user's trial_tenders_count should increase" do
        Timecop.freeze(Date.today + 2.months) do
          current_tender_page.seed_data
          current_tender_page.visit_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          expect(yet_to_subscribe_user.trial_tenders_count).to eq 0
          current_tender_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          current_tender_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(yet_to_subscribe_user.reload.trial_tenders_count).to eq 1
        end
      end

      scenario "trial_tenders should have the correct tender and user info" do
        Timecop.freeze(Date.today + 2.months) do
          current_tender_page.seed_data
          current_tender_page.visit_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          first_tender_description = current_tender_page.find_css('tbody tr td')[0].all_text
          current_tender_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          current_tender_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(TrialTender.count).to eq 1
          expect(TrialTender.first.user_id).to eq yet_to_subscribe_user.id
          expect(Tender.find(TrialTender.first.tender_id)).to eq Tender.find_by_description(first_tender_description)
        end
      end

      scenario "should be able to view the full details of a non inhouse tender once unlocked" do
        Timecop.freeze(Date.today + 2.months) do
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
          current_tender_page.visit_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          current_tender_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          expect(page).not_to have_content 'Buyer Company Name'
          expect(page).not_to have_content 'Buyer Name'
          expect(page).not_to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'
          current_tender_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).to have_content 'Original Link'
        end
      end

      scenario "should be able to view the full details of a inhouse tender once unlocked" do
        Timecop.freeze(Date.today + 2.months) do
          Tender.create(
            ref_no: Faker::Company.ein,
            buyer_company_name: Faker::Company.name,
            buyer_contact_number: Faker::PhoneNumber.phone_number,
            buyer_name: Faker::Name.name,
            buyer_email: Faker::Internet.email,
            description: Faker::Lorem.sentences(5).join(" "),
            long_description: Faker::Lorem.sentences(5).join(" "),
            published_date: Faker::Date.between(7.days.ago, Time.now.in_time_zone('Singapore').to_date),
            closing_datetime: Faker::Time.between(DateTime.now + 7.days, DateTime.now + 21.days)
          )
          current_tender_page.visit_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          current_tender_page.click_common '.more-button'
          
          expect(page).to have_selector '#view-more-modal'
          expect(page).not_to have_content 'Buyer Company Name'
          expect(page).not_to have_content 'Buyer Name'
          expect(page).not_to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'
          current_tender_page.click_unique '#buy-details'
          wait_for_ajax
          
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).not_to have_content 'Original Link'
        end
      end

      scenario "should be able to view the full details of a non inhouse tender for the whole day" do
        Timecop.freeze(Date.today + 2.months) do
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
          current_tender_page.visit_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          
          current_tender_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          current_tender_page.click_unique '#buy-details'
          current_tender_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          
          current_tender_page.visit_page
          wait_for_page_load
          
          current_tender_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
          expect(page).to have_content 'Original Link'
        end
      end

      scenario "should be able to view the full details of a inhouse tender for the whole day" do
        Timecop.freeze(Date.today + 2.months) do
          Tender.create(
            ref_no: Faker::Company.ein,
            buyer_company_name: Faker::Company.name,
            buyer_contact_number: Faker::PhoneNumber.phone_number,
            buyer_name: Faker::Name.name,
            buyer_email: Faker::Internet.email,
            description: Faker::Lorem.sentences(5).join(" "),
            long_description: Faker::Lorem.sentences(5).join(" "),
            published_date: Faker::Date.between(7.days.ago, Time.now.in_time_zone('Singapore').to_date),
            closing_datetime: Faker::Time.between(DateTime.now + 7.days, DateTime.now + 21.days)
          )
          current_tender_page.visit_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          
          current_tender_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          current_tender_page.click_unique '#buy-details'
          current_tender_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          
          current_tender_page.visit_page
          wait_for_page_load
          
          current_tender_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          expect(page).to have_content 'Buyer Company Name'
          expect(page).to have_content 'Buyer Name'
          expect(page).to have_content 'Buyer Contact Number'
        end
      end

      scenario 'cannot reveal details once hit limit' do
        Timecop.freeze(Date.today + 2.months) do
          current_tender_page.seed_data
          current_tender_page.visit_page
          wait_for_page_load
          yet_to_subscribe_user.reload
          first_tender_description = current_tender_page.find_css('tbody tr td')[0].all_text
          
          current_tender_page.click_common '.more-button'
          expect(page).to have_selector '#view-more-modal'
          current_tender_page.click_unique '#buy-details'
          current_tender_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          current_tender_page.click_common '.more-button', 1
          expect(page).to have_selector '#view-more-modal'
          current_tender_page.click_unique '#buy-details'
          current_tender_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'
          current_tender_page.click_common '.more-button', 2
          expect(page).to have_selector '#view-more-modal'
          current_tender_page.click_unique '#buy-details'
          current_tender_page.click_common '.close-reveal-modal'
          expect(page).not_to have_selector '#view-more-modal'

          current_tender_page.click_common '.more-button', 3
          expect(page).to have_selector '#view-more-modal'
          expect(page).to have_content 'You have used up your credits for the day to unlock business leads.'
          expect(page).to have_link 'SUBSCRIBE now', href: '/subscribe'
        end
      end

    end

  end

end