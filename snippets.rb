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

# things to run before implementing braintree
User.all.each do |user|
  result = Braintree::Customer.create(
    first_name: user.first_name,
    last_name: user.last_name,
    email: user.email,
    company: user.company_name
  )
  user.update(braintree_customer_id: result.customer.id)
end