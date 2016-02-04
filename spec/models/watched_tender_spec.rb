require "spec_helper"

feature WatchedTender, type: :model do
  it { should belong_to(:tender) }
  it { should belong_to(:current_tender).with_foreign_key(:tender_id) }
  it { should belong_to(:past_tender).with_foreign_key(:tender_id) }
  it { should belong_to(:user) }
end