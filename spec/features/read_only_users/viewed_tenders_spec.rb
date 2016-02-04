require 'spec_helper'

feature 'viewed_tenders', type: :feature, js: true do
  let(:tenders_page) { TendersPage.new }
  let(:user) { create(:user, :read_only) }
  let!(:inhouse_tender) { create(:tender, :inhouse) }

  before :each do
    login_as(user, scope: :user)
  end

  scenario 'should increase viewed_tenders count by 1' do
    tenders_page.visit_current_tenders_page
    wait_for_page_load
    tenders_page.click_common '.more-button'
    wait_for_ajax
    expect(page).to have_selector '#view-more-modal'
    expect(ViewedTender.count).to eq 0
    tenders_page.click_unique '#ga-tender-inhouse-more'

    wait_for_ajax
    expect(ViewedTender.count).to eq 1
    viewed_tender = ViewedTender.first
    expect(viewed_tender.user_id).to eq user.id
    expect(viewed_tender.ref_no).to eq inhouse_tender.ref_no
  end

end