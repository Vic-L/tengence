namespace :maintenance do
  task :cleanup_past_tenders => :environment do
    ref_nos = Tender.non_inhouse.where("closing_datetime < ?", Time.now.beginning_of_day - 1.month).pluck(:ref_no)
    if ref_nos.blank?
      NotifyViaSlack.call(content: "No ancient tenders on AWSCloudSearch")
    else
      WatchedTender.where(tender_id: ref_nos).destroy_all
      Tender.where(ref_no: ref_nos).delete_all
      
      array = []
      ref_nos.each do |ref_no|
        array << {
          'type': "delete",
          'id': ref_no
        }
      end; nil
      response = AwsManager.upload_document array.to_json

      if response.class == String
        NotifyViaSlack.call(content: "<@vic-l> ERROR removing ancient tenders from AWSCloudSearch!!\r\n#{response}")
      else
        NotifyViaSlack.call(content: "Removed ancient tenders on AWSCloudSearch")
      end
    end
  end
end