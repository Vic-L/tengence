require 'spec_helper'

feature 'redirection', type: :feature do
  let(:devise_page) { DevisePage.new }
  let(:tenders_page) { TendersPage.new }
  let!(:user) { create(:user, :subscribed_one_month)}
  let(:tender) { create(:tender) }

  scenario 'user should be redirected to tenders#show page after logging in if they came from email' do
    tenders_page.visit_show_tender_page tender.ref_no, utm_medium: "email"
    expect(page.current_path).to eq new_user_session_path

    devise_page.fill_up_login_form user.email, 'password'
    devise_page.click_unique '#submit'
    expect(page).to have_content 'Signed in successfully.'
    expect(page.current_path).to eq custom_tender_path(tender)
  end

end