# add to cloudsearch
array = []
Tender.all.each do |tender|
  array << {
    'type': "add",
    'id': tender.ref_no,
    'fields': {
      'ref_no': tender.ref_no,
      'description': tender.description
    }
  }
end; nil
AwsManager.upload_document array.to_json



array = []
Tender.all.each do |tender|
  array << {
    'type': "delete",
    'id': tender.ref_no
  }
end; nil
AwsManager.upload_document array.to_json