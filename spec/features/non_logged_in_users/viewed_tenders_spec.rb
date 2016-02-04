require 'spec_helper'

feature 'viewed_tenders', type: :feature, js: true do
  let(:home_page) { HomePage.new }
  let!(:inhouse_tender) { create(:tender, :inhouse) }

  scenario 'should not increase count by 1' do
    home_page.visit_page
    wait_for_page_load
    home_page.click_common '.more-button'
    wait_for_ajax
    expect(page).to have_selector '#view-more-modal'
    expect(ViewedTender.count).to eq 0
    home_page.click_unique '#ga-tender-inhouse-more'
    wait_for_ajax
    expect(ViewedTender.count).not_to eq 1
  end

end