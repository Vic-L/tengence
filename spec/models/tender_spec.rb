require "spec_helper"

feature Tender, type: :model do
  it { should strip_attribute :buyer_name }
  it { should strip_attribute :buyer_email }
  it { should strip_attribute :buyer_contact_number }
  it { should strip_attribute :description }
  it { should strip_attribute :long_description }

  it { should have_many(:watched_tenders).dependent(:destroy) }
  it { should have_many(:users).through(:watched_tenders) }
  it { should have_many(:viewed_tenders).with_foreign_key(:ref_no).dependent(:destroy) }
  it { should have_many(:trial_tenders).dependent(:destroy) }

  it { should have_many(:documents).dependent(:destroy) }

  it { should callback(:add_to_cloudsearch).after(:commit).on(:create) }
  it { should callback(:update_cloudsearch).before(:update) }
  it { should callback(:remove_from_cloudsearch).after(:commit).on(:destroy) }
  it { should callback(:add_thinking_sphinx_id).before(:create) }

  it { should accept_nested_attributes_for(:documents).allow_destroy(true) }

  it { should validate_presence_of :published_date }
  it { should validate_presence_of :closing_datetime }
  it { should_not validate_presence_of :buyer_name }
  it { should_not validate_presence_of :buyer_email }
  it { should_not validate_presence_of :buyer_contact_number }

  feature 'scopes' do

    feature 'non_sesami' do

      let!(:sesami_tender) { create(:sesami_tender) }
      let!(:tender) { create(:non_gebiz_tender) }
      let!(:gebiz_tender) { create(:gebiz_tender) }
      let!(:inhouse_tender) { create(:inhouse_tender) }

      scenario 'should not include sesami_tender' do
        expect(Tender.non_sesami.count).to eq 3
        expect(Tender.non_sesami.include? sesami_tender).to eq false
      end

      scenario 'should include inhouse_tender where external_link is nil' do
        expect(Tender.non_sesami.include? inhouse_tender).to eq true
      end

    end

  end

end