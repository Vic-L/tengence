class CurrentTendersPage
  include Capybara::DSL

  def visit_page
    visit '/current_tenders'
    self
  end

  def find_css selector
    page.driver.find_css selector
  end

  def sort_by_newest
    find_css('select.sort').first.find_xpath('option').first.click
  end

  def sort_by_expiring
    find_css('select.sort').first.find_xpath('option').last.click
  end

  def get_first_published_date
    find_css('tbody tr td')[1].all_text.to_date
  end

  def get_last_published_date
    find_css('tbody tr:last-child td')[1].all_text.to_date
  end

  def get_all_descriptions
    array = []
    find_css('tbody tr').each do |tr|
      array << tr.find_css('td')[0].all_text
    end
    array
  end

end