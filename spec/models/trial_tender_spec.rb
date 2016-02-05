require "spec_helper"

feature TrialTender, type: :model do
  it { should belong_to(:user).counter_cache(true) }
  it { should belong_to(:tender) }
  it { should validate_uniqueness_of(:tender_id).scoped_to(:user_id) }
end