class String
  def custom_uri_encode
    gsub("-","%252D").
    gsub("_","%255F").
    gsub("~","%257E").
    gsub("!","%2521").
    gsub("'","%2591").
    gsub("(","%2528").
    gsub(")","%2529").
    gsub("*","%252A").
    gsub(".","%252E").
    gsub("/","%252F")
  end
end