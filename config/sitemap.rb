require 'rubygems'
require 'sitemap_generator'
# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.tengence.com.sg"

SitemapGenerator::Sitemap.sitemaps_path = 'shared/'

SitemapGenerator::Sitemap.create do
  add register_path
  add new_user_session_path
  add terms_of_service_path
  add faq_path
  add root_path
end
