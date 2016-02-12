class AwsManager
  def self.upload_document json
    if Rails.env.production?
      # check if more than 5 mb
      begin
        if json.bytesize > 5000000
          raise "File is too large"
        else
          JSON.parse(json) # will raise exception
          client = Aws::CloudSearchDomain::Client.new(endpoint: ENV['AWS_CLOUDSEARCH_DOCUMENT_ENDPOINT'])
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
    else
      puts "Upload documents to AWSCloudSearch - #{Rails.env}"
      return "success"
    end
  end

  def self.search keyword:, cursor: nil
    keyword.downcase!
    Rails.cache.fetch("AWSCloudSearch-#{keyword}") {
      client = Aws::CloudSearchDomain::Client.new(endpoint: ENV['AWS_CLOUDSEARCH_SEARCH_ENDPOINT'])
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
          operators: ['and','escape','not','or','phrase','precedence','prefix']
        }.to_json,
        query_parser: "simple", # accepts simple, structured, lucene, dismax
        'return': ['description', 'ref_no'].join(','),
        size: 10000,
        # sort: "Sort",
        # start: 0
      })
      ref_nos = resp.hits.hit.map do |result|
        result.fields["ref_no"][0]
      end
    }
  end
end
# resp = client.search({filter_query: fq,query: keyword,query_options: {fields: ['description'],operators: ['and','escape','near','not','or','phrase']}.to_json,query_parser: "simple",'return': ['description', 'ref_no'].join(','),size: 10000})