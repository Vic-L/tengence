class CurrentTendersPage
  include Capybara::DSL

  def visit_page
    visit '/current_tenders'
    self
  end

  def find_css selector
    page.driver.find_css selector
  end
end