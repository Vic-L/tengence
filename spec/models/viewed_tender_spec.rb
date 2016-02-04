require "spec_helper"

feature ViewedTender, type: :model do
  it { should belong_to(:tender).with_foreign_key(:ref_no) }
  it { should belong_to(:user) }
end