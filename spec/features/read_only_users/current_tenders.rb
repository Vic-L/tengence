require 'spec_helper'

feature 'current_tenders', js: true do
  let(:current_tenders_page) { CurrentTendersPage.new }
  let(:read_only_user) {create(:user, :read_only)}

  before :each do
    Rails.application.load_seed
    login_as(read_only_user, scope: :user)
    current_tenders_page.visit_page
    page.driver.browser.manage.window.resize_to(1432, 782)
  end
  
  scenario 'should work' do
    using_wait_time 10 do
      expect(first('span.total-count').text).to eq '102'

      first_description = first('tbody td').text

      first('nav.pagination a:last-child').click
      second_description = first('tbody td').text
      expect(second_description).not_to eq first_description
    end
  end
end