require 'spec_helper'

feature "access pages by write_only users" do
  let(:tenders_page) { TendersPage.new }
  let(:write_only_user) {create(:user, :write_only)}
  let(:write_only_user_without_keywords) {create(:user, :write_only, :without_keywords)}

  feature 'with keywords' do

    before :each do
      login_as(write_only_user, scope: :user)
    end

    scenario 'home_page' do
      tenders_page.visit_home_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
    end

    scenario 'current_tenders' do
      tenders_page.visit_current_tenders_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
      expect(tenders_page).to have_content 'You are not authorized to view this page.'
    end

    scenario 'past_tenders' do
      tenders_page.visit_past_tenders_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
      expect(tenders_page).to have_content 'You are not authorized to view this page.'
    end

    scenario 'keywords_tenders' do
      tenders_page.visit_keywords_tenders_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
      expect(tenders_page).to have_content 'You are not authorized to view this page.'
    end

    scenario 'watched_tenders' do
      tenders_page.visit_watched_tenders_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
      expect(tenders_page).to have_content 'You are not authorized to view this page.'
    end

    scenario 'new_tender' do
      tenders_page.visit_new_tender_page
      expect(tenders_page.current_path).to eq new_tender_path
    end

    scenario 'current_posted_tenders' do
      tenders_page.visit_current_posted_tenders_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
    end

    scenario 'past_posted_tenders' do
      tenders_page.visit_past_posted_tenders_page
      expect(tenders_page.current_path).to eq past_posted_tenders_path
    end

  end

  feature 'without keywords' do

    before :each do
      login_as(write_only_user_without_keywords, scope: :user)
    end

    scenario 'home_page' do
      tenders_page.visit_home_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
      expect(tenders_page).not_to have_content 'You are not authorized to view this page.'
    end

    scenario 'current_tenders' do
      tenders_page.visit_current_tenders_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
      expect(tenders_page).to have_content 'You are not authorized to view this page.'
    end

    scenario 'past_tenders' do
      tenders_page.visit_past_tenders_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
      expect(tenders_page).to have_content 'You are not authorized to view this page.'
    end

    scenario 'keywords_tenders' do
      tenders_page.visit_keywords_tenders_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
      expect(tenders_page).to have_content 'You are not authorized to view this page.'
    end

    scenario 'watched_tenders' do
      tenders_page.visit_watched_tenders_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
      expect(tenders_page).to have_content 'You are not authorized to view this page.'
    end

    scenario 'new_tender' do
      tenders_page.visit_new_tender_page
      expect(tenders_page.current_path).to eq new_tender_path
    end

    scenario 'current_posted_tenders' do
      tenders_page.visit_current_posted_tenders_page
      expect(tenders_page.current_path).to eq current_posted_tenders_path
    end

    scenario 'past_posted_tenders' do
      tenders_page.visit_past_posted_tenders_page
      expect(tenders_page.current_path).to eq past_posted_tenders_path
    end

  end
end