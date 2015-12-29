atom_feed do |feed|
  feed.title "Open Tender matching your keywords"
  feed.updated @latest_updated_datetime
  @tenders.each do |tender|
    feed.entry tender, published: tender.published_date do |entry|
      entry.ref_no
    end
  end
end