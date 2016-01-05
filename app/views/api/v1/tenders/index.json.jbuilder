json.results_count @results_count
json.pagination do
  json.path request.path
  json.current_page @current_page
  json.total_pages @total_pages
  json.limit_value @limit_value
  json.last_page @last_page
end
json.tenders do
  json.array! @tenders do |tender|
    json.ref_no tender.ref_no
    json.status tender.status
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
    json.watched tender.watched?(@watched_tender_ids)
  end
end
