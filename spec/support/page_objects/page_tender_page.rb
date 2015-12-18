class PostTenderPage
  include Capybara::DSL

  def visit_page
    visit '/tenders/new'
    self
  end

  def press_create_tender_button
    binding.pry
    find('#submit').click
  end
end
