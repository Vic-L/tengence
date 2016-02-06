module TendersHelper

  def tender_already_unlocked? trial_tender_ids,ref_no
    trial_tender_ids.include? ref_no
  end

end
