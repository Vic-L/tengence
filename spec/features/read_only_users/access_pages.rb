require 'spec_helper'

feature "access pages by read_only users" do
  let(:tenders_page) { TendersPage.new }
  let(:read_only_user) {create(:user, :read_only)}
  let(:read_only_user_without_keywords) {create(:user, :read_only, :without_keywords)}

  feature 'with keywords' do

    before :each do
      login_as(read_only_user, scope: :user)
    end

    scenario 'home_page' do
      tenders_page.visit_home_page
      expect(tenders_page.current_path).to eq current_tenders_path
    end

    scenario 'current_tenders' do
      tenders_page.visit_current_tenders_page
      expect(tenders_page.current_path).to eq current_tenders_path
    end

    scenario 'past_tenders' do
      tenders_page.visit_past_tenders_page
      expect(tenders_page.current_path).to eq past_tenders_path
    end

    scenario 'keywords_tenders' do
      tenders_page.visit_keywords_tenders_page
      expect(tenders_page.current_path).to eq keywords_tenders_path
    end

    scenario 'watched_tenders' do
      tenders_page.visit_watched_tenders_page
      expect(tenders_page.current_path).to eq watched_tenders_path
    end

    scenario 'post-a-tender' do
      tenders_page.visit_post_a_tender_page
      expect(tenders_page.current_path).not_to eq '/post-a-tender'
      expect(tenders_page.current_path).to eq current_tenders_path
      expect(tenders_page).to have_content 'You are not authorized to view this page.'
    end

    scenario 'new_tender' do
      tenders_page.visit_new_tender_page
      expect(tenders_page.current_path).not_to eq new_tender_path
      expect(tenders_page.current_path).to eq current_tenders_path
      expect(tenders_page).to have_content 'You are not authorized to view this page.'
    end

    scenario 'current_posted_tenders' do
      tenders_page.visit_current_posted_tenders_page
      expect(tenders_page.current_path).not_to eq current_posted_tenders_path
      expect(tenders_page.current_path).to eq current_tenders_path
      expect(tenders_page).to have_content 'You are not authorized to view this page.'
    end

  end

  feature 'without keywords' do

    before :each do
      login_as(read_only_user_without_keywords, scope: :user)
    end

    scenario 'home_page' do
      tenders_page.visit_home_page
      expect(tenders_page.current_path).to eq keywords_tenders_path
      expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
    end

    scenario 'current_tenders' do
      tenders_page.visit_current_tenders_page
      expect(tenders_page.current_path).to eq keywords_tenders_path
      expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
    end

    scenario 'past_tenders' do
      tenders_page.visit_past_tenders_page
      expect(tenders_page.current_path).to eq keywords_tenders_path
      expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
    end

    scenario 'keywords_tenders' do
      tenders_page.visit_keywords_tenders_page
      expect(tenders_page.current_path).to eq keywords_tenders_path
      expect(tenders_page).not_to have_content 'Get started with Tengence by filling in keywords related to your business.'
    end

    scenario 'watched_tenders' do
      tenders_page.visit_watched_tenders_page
      expect(tenders_page.current_path).to eq keywords_tenders_path
      expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
    end

    scenario 'post-a-tender' do
      tenders_page.visit_post_a_tender_page
      expect(tenders_page.current_path).not_to eq '/post-a-tender'
      expect(tenders_page.current_path).to eq keywords_tenders_path
      expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
    end

    scenario 'new_tender' do
      tenders_page.visit_new_tender_page
      expect(tenders_page.current_path).not_to eq new_tender_path
      expect(tenders_page.current_path).to eq keywords_tenders_path
      expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
    end

    scenario 'current_posted_tenders' do
      tenders_page.visit_current_posted_tenders_page
      expect(tenders_page.current_path).not_to eq current_posted_tenders_path
      expect(tenders_page.current_path).to eq keywords_tenders_path
      expect(tenders_page).to have_content 'Get started with Tengence by filling in keywords related to your business.'
    end

  end
end