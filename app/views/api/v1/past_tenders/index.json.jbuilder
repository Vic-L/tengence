json.results_count @results_count
json.tenders do
  json.array! @tenders do |tender|
    json.ref_no tender.ref_no
    json.closing_datetime tender.closing_datetime
    json.published_date tender.published_date
    json.description tender.description
    json.long_description tender.long_description
    json.budget tender.budget
    json.buyer_email tender.buyer_email
    json.buyer_company_name tender.buyer_company_name
    json.watch_path watched_tenders_path(id: tender.ref_no)
    json.unwatch_path watched_tender_path(id: tender.ref_no)
    json.show_path tender_path(id: tender.ref_no)
    json.watched tender.watched?(current_user.id)
  end
end