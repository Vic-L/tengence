class AwsManager
  def self.upload_document json
    # check if more than 5 mb
    begin
      if json.bytesize > 5000000
        raise "File is too large"
      else
        JSON.parse(json) # will raise exception
        client = Aws::CloudSearchDomain::Client.new(endpoint: ENV['AWS_CLOUDSEARCH_ENDPOINT'])
        resp = client.upload_documents({
          documents: json, # file/IO object, or string data, required
          content_type: "application/json", # required, accepts application/json, application/xml
        })
      end
      return resp # return a Seahorse::Client::Response
    rescue JSON::ParserError => e
      return e.message
    rescue => e
      return e.message
    end
  end

  def self.search keyword:, cursor: nil
    client = Aws::CloudSearchDomain::Client.new(endpoint: ENV['AWS_CLOUDSEARCH_ENDPOINT'])
    resp = client.search({
      cursor: cursor || "initial",
      # expr: "Expr",
      # facet: "Facet",
      # filter_query: "FilterQuery",
      # highlight: "Highlight",
      # partial: true,
      query: keyword, # required
      query_options: {
        fields: ['description'],
        operators: ['and','escape','fuzzy','near','not','or','phrase','precedence','prefix']
      }.to_json,
      query_parser: "simple", # accepts simple, structured, lucene, dismax
      'return': ['description', 'ref_no'].join(','),
      size: 10000,
      # sort: "Sort",
      # start: 0
    })
  end

  def self.watched_tenders_search keyword:, ref_nos_array: nil
    if ref_nos_array.blank?
      fq = ""
    else
      fq = "(or"
      ref_nos_array.each do |ref_no|
        fq += " ref_no:'#{ref_no}'"
      end
      fq += ")"
    end

    client = Aws::CloudSearchDomain::Client.new(endpoint: ENV['AWS_CLOUDSEARCH_ENDPOINT'])
    resp = client.search({
      # cursor: "initial",
      # expr: "Expr",
      # facet: "Facet",
      filter_query: fq,
      # highlight: "Highlight",
      # partial: true,
      query: keyword, # required
      query_options: {
        fields: ['description'],
        operators: ['and','escape','fuzzy','near','not','or','phrase','precedence','prefix']
      }.to_json,
      query_parser: "simple", # accepts simple, structured, lucene, dismax
      'return': ['description', 'ref_no'].join(','),
      size: 10000,
      # sort: "Sort",
      # start: 0
    })
  end
end