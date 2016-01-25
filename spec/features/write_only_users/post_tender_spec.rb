require 'spec_helper'

feature "post tender", js: true, type: :feature do
  let(:user) {create(:user, :write_only)}
  let(:post_tender_page) { PostTenderPage.new }

  before :each do
    page.driver.browser.manage.window.resize_to(1432, 782)
    login_as(user, :scope => :user)
    post_tender_page.visit_page
  end

  feature 'validations' do
    scenario 'with nothing filled' do
      wait_for_page_load
      post_tender_page.press_create_tender_button
      expect(page).to have_content("A short description of your buying requirement is required")
      expect(page).to have_content("Name of person of contact is required")
      expect(page).to have_content("Email of person of contact is required")
      expect(page).to have_content("Contact number of the person of contact is required")
      expect(page).not_to have_content("budget")
      expect(page).to have_content("Closing date time required")
      expect(page).to have_content("Tender description is required")
    end
  end

  feature "successfully" do
    before :each do
      wait_for_page_load
      post_tender_page.fill_up_form
    end
    
    scenario "without documents" do
      post_tender_page.press_create_tender_button

      expect(page).to have_content("Tender Created Successfully!")
      expect(Tender.first.ref_no).to have_content "InHouse-" # this should be model test
      expect(page.current_path).to eq current_posted_tenders_path
    end

    scenario "with 1 document" do
      upload_button_id = post_tender_page.find_css('fieldset').first.find_css("input[type='file']").first['id']
      file_path = "#{Rails.root}/Gemfile"
      post_tender_page.upload_file(upload_button_id, file_path)
      post_tender_page.press_create_tender_button

      expect(page).to have_content("Tender Created Successfully!")
      expect(Tender.first.ref_no).to have_content "InHouse-" # this should be model test
      expect(Tender.first.documents.count).to eq 1
      expect(page.current_path).to eq current_posted_tenders_path
    end

    scenario "with multiple documents" do
      post_tender_page.upload_2_files
      post_tender_page.press_create_tender_button

      expect(page).to have_content("Tender Created Successfully!")
      expect(Tender.first.ref_no).to have_content "InHouse-" # this should be model test
      expect(Tender.first.documents.count).to eq 2
      filenames = Tender.first.documents.map{|doc| doc.upload.original_filename}
      expect(filenames.include?('Capfile')).to eq true
      expect(filenames.include?('Gemfile')).to eq true
      expect(page.current_path).to eq current_posted_tenders_path
    end

    scenario "with documents that are removed after inputting and blank" do
      post_tender_page.upload_2_files_then_remove_first
      post_tender_page.upload_blank_file
      post_tender_page.press_create_tender_button

      expect(page).to have_content("Tender Created Successfully!")
      expect(Tender.first.ref_no).to have_content "InHouse-" # this should be model test
      expect(Tender.first.documents.count).to eq 1
      expect(Tender.first.documents.first.upload.original_filename).to eq 'Capfile'
      expect(page.current_path).to eq current_posted_tenders_path
    end
  end
end