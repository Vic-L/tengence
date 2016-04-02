require 'spec_helper'

feature 'errors', js: true, type: :feature do
  let(:current_tenders_page) { CurrentTendersPage.new }
  let(:user) {create(:user)}

  before :each do
    current_tenders_page.seed_data
    login_as(user, scope: :user)
    current_tenders_page.visit_page
    wait_for_page_load
    page.driver.browser.manage.window.resize_to(1432, 782)
  end

  scenario "should refresh current tenders page if user is deleted" do
    logout(:user)
    user.destroy

    current_tenders_page.click_unique ".search-submit-button"
    # expect(current_tenders_page.alert_text).to have_content "Sorry you are not authorized to visit this page."
    # expect(current_tenders_page.alert_text).not_to have_content "Our developers are notified and are working on it."
    current_tenders_page.accept_confirm

    expect(page.current_path).to eq root_path
  end
end