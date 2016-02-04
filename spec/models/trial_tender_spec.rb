require "spec_helper"

feature TrialTender, type: :model do
  it { should belong_to(:user).counter_cache(true) }
  it { should belong_to(:tender) }
end