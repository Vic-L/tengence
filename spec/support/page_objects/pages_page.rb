class PagesPage
  include TendersPageFunctions

  def visit_home_page
    visit '/'
    self
  end

  def visit_faq_page
    visit '/faq'
    self
  end

  def visit_terms_of_service_page
    visit '/terms-of-service'
    self
  end

end