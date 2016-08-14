json.results_count @results_count
json.pagination do
  json.path request.path
  json.current_page @current_page
  json.total_pages @total_pages
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
    json.buyer_email tender.buyer_email
    json.buyer_company_name tender.buyer_company_name
    json.watched tender.watched?(@watched_tender_ids)
  end
end
