class CurrentTendersPage
  include Capybara::DSL

  def visit_page
    visit '/current_tenders'
    self
  end
end