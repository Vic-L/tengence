require 'spec_helper'

feature 'current_tenders', js: true, type: :feature do
  let(:current_tenders_page) { CurrentTendersPage.new }
  let(:read_only_user) {create(:user, :read_only)}

  before :each do
    Rails.application.load_seed
    login_as(read_only_user, scope: :user)
    current_tenders_page.visit_page
    page.driver.browser.manage.window.resize_to(1432, 782)
  end
  
  scenario 'should work' do
    expect(current_tenders_page.find_css('span.total-count').first.all_text).to eq '102'
    first_description = current_tenders_page.find_css('tbody td').first.all_text
    current_tenders_page.find_css('nav.pagination a').last.click
    wait_for_ajax
    second_description = current_tenders_page.find_css('tbody td').first.all_text
    
    expect(second_description).not_to eq first_description
  end
end