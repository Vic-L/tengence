require 'spec_helper'

feature 'current_posted_tenders', js: true, type: :feature do
  let(:current_posted_tenders_page) { CurrentPostedTendersPage.new }
  let(:write_only_user) {create(:user, :write_only)}

  before :each do
    current_posted_tenders_page.seed_data write_only_user.id
    login_as(write_only_user, scope: :user)
    current_posted_tenders_page.visit_page
    wait_for_page_load
    page.driver.browser.manage.window.resize_to(1432, 782)
  end
  
  scenario 'should have link to post tender' do
    expect(current_posted_tenders_page.find_css('#post-a-tender-button').first.all_text).to eq 'Post a Buying Requirement'
    current_posted_tenders_page.click_unique '#post-a-tender-button'
    expect(page.current_path).to eq new_tender_path
  end

  scenario 'should display correct count and thus not show past tenders' do
    expect(current_posted_tenders_page.find_css('span.total-count').first.all_text).to eq '102'
    expect(current_posted_tenders_page.find_css('span.total-count').last.all_text).to eq '102'
  end

  scenario 'should paginate correctly' do
    descriptions = current_posted_tenders_page.get_all_descriptions
    current_posted_tenders_page.click_common 'nav.pagination a', -2
    wait_for_ajax
    
    descriptions << current_posted_tenders_page.get_all_descriptions
    current_posted_tenders_page.click_common 'nav.pagination a', -2
    wait_for_ajax
    
    descriptions << current_posted_tenders_page.get_all_descriptions
    
    expect(descriptions.flatten.count).to eq descriptions.flatten.uniq.count
  end

  scenario 'should sort correctly' do
    expect(current_posted_tenders_page.find_css('select.sort').first.value).to eq 'newest'
    expect(current_posted_tenders_page.find_css('select.sort').last.value).to eq 'newest'
    first_published_date = current_posted_tenders_page.get_first_published_date.to_date
    last_published_date = current_posted_tenders_page.get_last_published_date.to_date
    expect(first_published_date > last_published_date).to eq true

    current_posted_tenders_page.sort_by_expiring
    wait_for_ajax

    expect(current_posted_tenders_page.find_css('select.sort').first.value).to eq 'expiring'
    expect(current_posted_tenders_page.find_css('select.sort').last.value).to eq 'expiring'

    first_closing_datetime = current_posted_tenders_page.get_first_closing_date_time.to_datetime
    last_closing_datetime = current_posted_tenders_page.get_last_closing_date_time.to_datetime
    expect(first_closing_datetime < last_closing_datetime).to eq true

    current_posted_tenders_page.sort_by_newest
    wait_for_ajax

    expect(current_posted_tenders_page.find_css('select.sort').first.value).to eq 'newest'
    expect(current_posted_tenders_page.find_css('select.sort').last.value).to eq 'newest'

    expect(current_posted_tenders_page.get_first_published_date.to_date).to eq first_published_date
    expect(current_posted_tenders_page.get_last_published_date.to_date).to eq last_published_date
  end

  scenario 'should show correct details for corresponding more button clicked' do
    expect(page).not_to have_selector('#view-more-modal')

    tender = current_posted_tenders_page.get_first_tender_details
    current_posted_tenders_page.click_common '.more-button'
    wait_for_ajax

    expect(page).to have_selector('#view-more-modal')
    expect(current_posted_tenders_page.get_view_more_modal_content).to have_content tender['closing_date']
    expect(current_posted_tenders_page.get_view_more_modal_content).to have_content tender['closing_time']
    expect(current_posted_tenders_page.get_view_more_modal_content).to have_content tender['description']
    expect(current_posted_tenders_page.get_view_more_modal_content).to have_content tender['published_date']
  end

  scenario 'should show time without any time zone conversion' do
    tender = current_posted_tenders_page.get_first_tender_details
    expect(Tender.where(description: tender['description']).first.closing_datetime.strftime('%H:%M %p')).to eq tender['closing_time']
  end

  scenario 'should not have link to edit tenders' do
    expect(current_posted_tenders_page.find_css('tbody tr td')[4].all_text).to eq 'Edit'
    expect(current_posted_tenders_page.find_css('tbody tr td')[4].all_text).not_to eq 'Expired'
  end

end