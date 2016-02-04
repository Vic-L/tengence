require 'spec_helper'

feature 'viewed_tenders', type: :feature, js: true do
  let(:tenders_page) { TendersPage.new }
  let(:user) { create(:user, :read_only) }
  let(:gebiz_tender) { create(:tender, :gebiz) }
  let(:non_gebiz_tender) { create(:tender, :non_gebiz) }
  let(:inhouse_tender) { create(:tender, :inhouse) }

  before :each do
    login_as(user, scope: :user)
  end

  feature 'popups' do

    feature 'gebiz_tender' do

      scenario 'should not have link to "show buyer details"' do
        gebiz_tender = create(:tender, :gebiz)
        tenders_page.visit_current_tenders_page
        wait_for_page_load
        tenders_page.click_common '.more-button'
        wait_for_ajax
        expect(page).to have_selector '#view-more-modal'

        expect(page).to have_content "Reference No"
        expect(page).to have_content "Buyer Company Name"
        expect(page).to have_content "Buyer Name"
        expect(page).to have_content "Buyer Email"
        expect(page).to have_content "Buyer Contact Number"
        expect(page).to have_content "Published Date"
        expect(page).to have_content "Closing Date"
        expect(page).to have_content "Closing Time"
        expect(page).to have_content "Description"
        expect(page).to have_content "Original Link"
        expect(page).not_to have_content "Full Description"
        expect(page).not_to have_selector '#in-house-tender-details'
        expect(page).not_to have_selector '#ga-tender-inhouse-more'
      end

    end

    feature 'non_gebiz_tender' do

      before :each do
        non_gebiz_tender = create(:tender, :non_gebiz)
      end

      scenario 'should not have link to "show buyer details"' do
        tenders_page.visit_current_tenders_page
        wait_for_page_load
        tenders_page.click_common '.more-button'
        wait_for_ajax
        expect(page).to have_selector '#view-more-modal'
        expect(page).not_to have_selector '#in-house-tender-details'

        expect(page).to have_content "Reference No"
        expect(page).to have_content "Buyer Company Name"
        expect(page).to have_content "Buyer Name"
        expect(page).to have_content "Buyer Email"
        expect(page).to have_content "Buyer Contact Number"
        expect(page).to have_content "Published Date"
        expect(page).to have_content "Closing Date"
        expect(page).to have_content "Closing Time"
        expect(page).to have_content "Description"
        expect(page).to have_content "Original Link"
        expect(page).not_to have_content "Full Description"
        expect(page).not_to have_selector '#in-house-tender-details'
        expect(page).not_to have_selector '#ga-tender-inhouse-more'
      end

      scenario 'should not have buyer details if tender does not have buyer details' do
        non_gebiz_tender.update(buyer_name: nil, buyer_contact_number: nil, buyer_email: nil)
        tenders_page.visit_current_tenders_page
        wait_for_page_load
        tenders_page.click_common '.more-button'
        wait_for_ajax
        expect(page).to have_selector '#view-more-modal'
        expect(page).not_to have_selector '#in-house-tender-details'

        expect(page).to have_content "Reference No"
        expect(page).to have_content "Buyer Company Name"
        expect(page).not_to have_content "Buyer Name"
        expect(page).not_to have_content "Buyer Email"
        expect(page).not_to have_content "Buyer Contact Number"
        expect(page).to have_content "Published Date"
        expect(page).to have_content "Closing Date"
        expect(page).to have_content "Closing Time"
        expect(page).to have_content "Description"
        expect(page).to have_content "Original Link"
        expect(page).not_to have_content "Full Description"
        expect(page).not_to have_selector '#in-house-tender-details'
        expect(page).not_to have_selector '#ga-tender-inhouse-more'
      end

    end

    feature 'inhouse_tender' do

      before :each do
        inhouse_tender = create(:tender, :inhouse)
      end

      scenario 'should have link to "show buyer details" and can show' do
        tenders_page.visit_current_tenders_page
        wait_for_page_load
        tenders_page.click_common '.more-button'
        wait_for_ajax

        expect(page).to have_selector '#view-more-modal'
        expect(page).to have_content "Reference No"
        expect(page).to have_content "Buyer Company Name"
        expect(page).not_to have_content "Buyer Name"
        expect(page).not_to have_content "Buyer Email"
        expect(page).not_to have_content "Buyer Contact Number"
        expect(page).to have_content "Published Date"
        expect(page).to have_content "Closing Date"
        expect(page).to have_content "Closing Time"
        expect(page).to have_content "Description"
        expect(page).not_to have_content "Original Link"
        expect(page).to have_content "Full Description"
        expect(page).to have_selector '#ga-tender-inhouse-more'
        tenders_page.click_unique '#ga-tender-inhouse-more'

        expect(page).to have_content "Reference No"
        expect(page).to have_content "Buyer Company Name"
        expect(page).to have_content "Buyer Name"
        expect(page).to have_content "Buyer Email"
        expect(page).to have_content "Buyer Contact Number"
        expect(page).to have_content "Published Date"
        expect(page).to have_content "Closing Date"
        expect(page).to have_content "Closing Time"
        expect(page).to have_content "Description"
        expect(page).not_to have_content "Original Link"
        expect(page).to have_content "Full Description"
        expect(page).to have_selector '#in-house-tender-details'
        expect(page).not_to have_selector '#ga-tender-inhouse-more'
      end

    end

  end

  pending 'tender show page' do

    feature 'gebiz_tender' do

      scenario 'should not have link to "show buyer details"' do
        gebiz_tender = create(:tender, :gebiz)
        tenders_page.visit_show_tender_page gebiz_tender.ref_no
        wait_for_page_load
        tenders_page.click_common '.more-button'
        wait_for_ajax
        expect(page).to have_selector '#view-more-modal'

        expect(page).to have_content "Reference No"
        expect(page).to have_content "Buyer Company Name"
        expect(page).to have_content "Buyer Name"
        expect(page).to have_content "Buyer Email"
        expect(page).to have_content "Buyer Contact Number"
        expect(page).to have_content "Published Date"
        expect(page).to have_content "Closing Date"
        expect(page).to have_content "Closing Time"
        expect(page).to have_content "Description"
        expect(page).to have_content "Original Link"
        expect(page).not_to have_content "Full Description"
        expect(page).not_to have_selector '#in-house-tender-details'
        expect(page).not_to have_selector '#ga-tender-inhouse-more'
      end

    end

    feature 'non_gebiz_tender' do

      before :each do
        non_gebiz_tender = create(:tender, :non_gebiz)
      end

      scenario 'should not have link to "show buyer details"' do
        tenders_page.visit_show_tender_page non_gebiz_tender.ref_no
        wait_for_page_load
        tenders_page.click_common '.more-button'
        wait_for_ajax
        expect(page).to have_selector '#view-more-modal'
        expect(page).not_to have_selector '#in-house-tender-details'

        expect(page).to have_content "Reference No"
        expect(page).to have_content "Buyer Company Name"
        expect(page).to have_content "Buyer Name"
        expect(page).to have_content "Buyer Email"
        expect(page).to have_content "Buyer Contact Number"
        expect(page).to have_content "Published Date"
        expect(page).to have_content "Closing Date"
        expect(page).to have_content "Closing Time"
        expect(page).to have_content "Description"
        expect(page).to have_content "Original Link"
        expect(page).not_to have_content "Full Description"
        expect(page).not_to have_selector '#in-house-tender-details'
        expect(page).not_to have_selector '#ga-tender-inhouse-more'
      end

      scenario 'should not have buyer details if tender does not have buyer details' do
        non_gebiz_tender.update(buyer_name: nil, buyer_contact_number: nil, buyer_email: nil)
        tenders_page.visit_show_tender_page non_gebiz_tender.ref_no
        wait_for_page_load
        tenders_page.click_common '.more-button'
        wait_for_ajax
        expect(page).to have_selector '#view-more-modal'
        expect(page).not_to have_selector '#in-house-tender-details'

        expect(page).to have_content "Reference No"
        expect(page).to have_content "Buyer Company Name"
        expect(page).not_to have_content "Buyer Name"
        expect(page).not_to have_content "Buyer Email"
        expect(page).not_to have_content "Buyer Contact Number"
        expect(page).to have_content "Published Date"
        expect(page).to have_content "Closing Date"
        expect(page).to have_content "Closing Time"
        expect(page).to have_content "Description"
        expect(page).to have_content "Original Link"
        expect(page).not_to have_content "Full Description"
        expect(page).not_to have_selector '#in-house-tender-details'
        expect(page).not_to have_selector '#ga-tender-inhouse-more'
      end

    end

    feature 'inhouse_tender' do

      before :each do
        inhouse_tender = create(:tender, :inhouse)
      end

      scenario 'should have link to "show buyer details" and can show' do
        tenders_page.visit_show_tender_page tender.ref_no
        wait_for_page_load
        tenders_page.click_common '.more-button'
        wait_for_ajax

        expect(page).to have_selector '#view-more-modal'
        expect(page).to have_content "Reference No"
        expect(page).to have_content "Buyer Company Name"
        expect(page).not_to have_content "Buyer Name"
        expect(page).not_to have_content "Buyer Email"
        expect(page).not_to have_content "Buyer Contact Number"
        expect(page).to have_content "Published Date"
        expect(page).to have_content "Closing Date"
        expect(page).to have_content "Closing Time"
        expect(page).to have_content "Description"
        expect(page).not_to have_content "Original Link"
        expect(page).to have_content "Full Description"
        expect(page).to have_selector '#ga-tender-inhouse-more'
        tenders_page.click_unique '#ga-tender-inhouse-more'

        expect(page).to have_content "Reference No"
        expect(page).to have_content "Buyer Company Name"
        expect(page).to have_content "Buyer Name"
        expect(page).to have_content "Buyer Email"
        expect(page).to have_content "Buyer Contact Number"
        expect(page).to have_content "Published Date"
        expect(page).to have_content "Closing Date"
        expect(page).to have_content "Closing Time"
        expect(page).to have_content "Description"
        expect(page).not_to have_content "Original Link"
        expect(page).to have_content "Full Description"
        expect(page).to have_selector '#in-house-tender-details'
        expect(page).not_to have_selector '#ga-tender-inhouse-more'
      end

    end

  end

end