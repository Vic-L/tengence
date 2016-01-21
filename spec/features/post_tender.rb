require 'spec_helper'

feature "post tender", js: true do
  let(:user) {create(:user, :write_only)}
  let(:post_tender_page) { PostTenderPage.new }

  before :each do
    page.driver.browser.manage.window.resize_to(1432, 782)
    login_as(user, :scope => :user)
    post_tender_page.visit_page
  end

  feature 'validations' do
    scenario 'with nothing filled' do
      post_tender_page.press_create_tender_button
      expect(page).to have_content("A short description of your buying requirement is required")
      expect(page).to have_content("Name of person of contact is required")
      expect(page).to have_content("Email of person of contact is required")
      expect(page).to have_content("Contact number of the person of contact is required")
      expect(page).not_to have_content("Budget range required")
      expect(page).to have_content("Closing date time required")
      expect(page).to have_content("Tender description is required")
    end
  end
end