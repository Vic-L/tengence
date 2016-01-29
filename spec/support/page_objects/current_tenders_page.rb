class CurrentTendersPage
  include Capybara::DSL
  include TendersPageFunctions

  def visit_page
    visit '/current_tenders'
    self
  end

end