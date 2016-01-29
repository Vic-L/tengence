require 'spec_helper'

feature 'edit tender', js: true, type: :feature do
  let(:tenders_page) { TendersPage.new }
  let(:write_only_user) {create(:user, :write_only)}
  let(:tender) {create(:tender, :inhouse, postee_id: write_only_user)}

  feature 'current_tender' do
    before :each do
      login_as(write_only_user, scope: :user)
      tenders_page.visit_edit_tender_page tender.ref_no
      wait_for_page_load
      page.driver.browser.manage.window.resize_to(1432, 782)
    end
    
    scenario 'nothing filled in' do
      fill_in 'tender_description', with: ''
      fill_in 'tender_buyer_name', with: ''
      fill_in 'tender_buyer_email', with: ''
      fill_in 'tender_buyer_contact_number', with: ''
      # fill up  closing date time without triggering disabled field on focus
      page.execute_script("$('#tender_closing_datetime').val('')")
      fill_in 'tender_long_description', with: ''

      tenders_page.click '#submit'

      expect(page).to have_content("A short description of your buying requirement is required")
      expect(page).to have_content("Name of person of contact is required")
      expect(page).to have_content("Email of person of contact is required")
      expect(page).to have_content("Contact number of the person of contact is required")
      expect(page).not_to have_content("budget")
      expect(page).to have_content("Closing date time required")
      expect(page).to have_content("Tender description is required")
    end

    scenario 'should persist changes' do
      description = tender.description
      buyer_name = tender.buyer_name
      # buyer_company_name = tender.buyer_company_name
      buyer_name = tender.buyer_name
      buyer_contact_number = tender.buyer_contact_number
      closing_datetime = tender.closing_datetime
      long_description = tender.long_description

      tenders_page.fill_up_tender_form
      tenders_page.click '#submit'

      expect(page).to have_content 'Buying requirement successfully updated!'
      expect(tender.reload.description).not_to eq description
      expect(tender.reload.buyer_name).not_to eq buyer_name
      # expect(tender.reload.buyer_company_name).not_to eq buyer_company_name
      expect(tender.reload.buyer_name).not_to eq buyer_name
      expect(tender.reload.buyer_contact_number).not_to eq buyer_contact_number
      expect(tender.reload.closing_datetime).not_to eq closing_datetime
      expect(tender.reload.long_description).not_to eq long_description
    end
  end

end