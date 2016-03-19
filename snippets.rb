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
User.find(2).update(default_payment_method_token: nil, next_billing_date: nil, auto_renew: false)
User.all.each do |user|
  result = Braintree::Customer.create(
    first_name: user.first_name,
    last_name: user.last_name,
    email: user.email,
    company: user.company_name
  )
  user.update(braintree_customer_id: result.customer.id)
end

['16389257','35682960','68855340','57551218','11321627','27122632','15748455','35263018','56893705','24036440','87640277','12709892','68441257','33839538','58232525','52720327','21253975','89091668','84205955','35411355','10639148','63162687','37183057','55331242','24650718','83992190','12175907','61428885','68926242','75588792','65028327','59749777','40569360','31548757','52459738','30368730','85489332','33729892','14314968','50602140','89215390','32740340','38282542','54429412','81848838','34552327','64681785','69948518','38596155','35698592','87566468','16820792','27408312','66249785','85428655','55153218','81132448','52555375','84837960','38269475','87247998','61375742','76322175','68844968','27979427','16515312','33133332'].each do |a|
  Braintree::Customer.delete(a)
end

#benchmarks
Benchmark.bm do |bm|
  bm.report{Tender.where('closing_datetime >= NOW() AND status = "open"').count}
  bm.report{CurrentTender.count}
end;nil

#### aws-cli ####
## add cache control to aws assets
# s3cmd modify --recursive --acl-public --add-header="Cache-Control:max-age=2592000" s3://geo-site/webroot/
# aws s3 cp /Users/L/Documents/tengence/app/assets/fonts/lato-v11-latin s3://tengence-alerts-production/static_assets/fonts/lato-v11-latin/ --recursive --acl public-read --cache-control "public,max-age=2628000"
## upoload cert to aws
# aws iam upload-server-certificate --server-certificate-name ssl_20160124 --certificate-body file:/Users/L/Documents/tengence/tengence-ssl/ssl-original.crt --private-key file:/Users/L/Documents/tengence/tengence-ssl/ssl.pem --certificate-chain file:/Users/L/Documents/tengence/tengence-ssl/ssl-intermediate.crt --path /cloudfront/production/


# things to do
# will test a subscription of 1 cent or 1 dollar

# holiday gem for automating emails
# front page
# email on unsent tenders
# quick feedback feature
# landing pages

# open links in our page?



### things to change soon
# getTenders notify error to refresh auto
# plans page accessible by non logged in users and to allow redirect nicely if they click from reminder email
# modernizer


## hotjar
# add more link to beside tender description
# reduce number of tenders in a page or make search bar always present
# after finish update keywrds, they dunno need to scroll down, so they click update again
# you have no keywords should be beside/below the update button
# redirect back to tender show when login after redirected to loogin page from email link
# pings on who subscribed or unsubscribed or subscribed to what plan