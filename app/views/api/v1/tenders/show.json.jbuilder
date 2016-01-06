json.ref_no @tender.ref_no
json.status @tender.status
json.closing_datetime @tender.closing_datetime
json.published_date @tender.published_date
json.description @tender.description
json.long_description @tender.long_description
json.budget @tender.budget
json.buyer_email @tender.buyer_email
json.buyer_company_name @tender.buyer_company_name
json.buyer_name @tender.buyer_name
json.buyer_contact_number @tender.buyer_contact_number
json.in_house @tender.in_house?
json.gebiz @tender.is_gebiz?
json.external_link @tender.external_link
json.documents do
  json.array! @tender.documents.collect do |doc|
    json.original_filename doc.upload.original_filename
    json.upload_size doc.upload.size
    json.url doc.upload.url
  end
end