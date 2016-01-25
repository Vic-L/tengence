require 'spec_helper'

feature 'keywords_tenders', js: true, type: :feature do
  let(:keywords_tenders_page) { KeywordsTendersPage.new }
  let(:user_without_keywords) {create(:user, :read_only,:without_keywords)}

  before :each do
    # Rails.application.load_seed
    login_as(user_without_keywords, scope: :user)
    keywords_tenders_page.visit_page
    page.driver.browser.manage.window.resize_to(1432, 782)
    wait_for_page_load
  end
  
  feature 'users with no keywords' do
    scenario 'when no keywords' do
      expect(page).to have_content 'You have no keywords. Start adding up to 20 keywords and get emails everyday on new tenders related to your set of keywords.'
    end

    scenario 'should add 1 keyword successfully' do
      keywords_tenders_page.add_1_keyword
      keywords_tenders_page.update_keywords
      wait_for_ajax
      expect(user_without_keywords.reload.keywords).not_to eq nil
    end

    scenario 'should add 2 keywords successfully' do
      keywords_tenders_page.add_2_keywords
      keywords_tenders_page.update_keywords
      wait_for_ajax
      expect(user_without_keywords.reload.keywords).not_to eq nil
      expect(user_without_keywords.reload.keywords.include?(',')).to eq true
    end

    scenario 'should add too many keywords unsuccessfully' do
      keywords_tenders_page.add_too_many_keywords(21)
      keywords_tenders_page.update_keywords
      expect(page.driver.browser.switch_to.alert.text).to eq "Keywords can't be more than 20"
    end
  end
end