atom_feed do |feed|
  feed.title "Open Tender matching your keywords"
  feed.updated @latest_updated_datetime
  @tenders.each do |tender|
    feed.entry tender, published: tender.published_date, url: tender_path(tender) do |entry|
      entry.title tender.ref_no
      entry.content tender.description
      entry.updated tender.published_date.to_datetime
      
      entry.author do |author|
        author.name tender.buyer_name
      end
    end
  end
end