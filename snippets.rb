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

#benchmarks
Benchmark.bm do |bm|
  bm.report{Tender.where('closing_datetime >= NOW() AND status = "open"').count}
  bm.report{CurrentTender.count}
end