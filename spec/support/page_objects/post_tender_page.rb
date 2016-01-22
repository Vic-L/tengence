class PostTenderPage
  include Capybara::DSL
  
  def visit_page
    visit '/tenders/new'
    self
  end

  def press_create_tender_button
    find_css('#submit').first.click
  end

  def find_css selector
    page.driver.find_css selector
  end
end
