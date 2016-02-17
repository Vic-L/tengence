class TendersPage
  include Capybara::DSL
  include TendersPageFunctions

  def visit_account_page
    visit '/users/edit'
    self
  end

  # read only
  def visit_current_tenders_page
    visit '/current_tenders'
    self
  end

  def visit_past_tenders_page
    visit '/past_tenders'
    self
  end

  def visit_keywords_tenders_page
    visit '/keywords_tenders'
    self
  end

  def visit_watched_tenders_page
    visit '/watched_tenders'
    self
  end

  # write only
  def visit_new_tender_page
    visit '/tenders/new'
    self
  end

  def visit_current_posted_tenders_page
    visit '/current_posted_tenders'
    self
  end

  def visit_past_posted_tenders_page
    visit '/past_posted_tenders'
    self
  end

  def visit_show_tender_page id
    visit '/tenders/' + id
    self
  end

  def visit_edit_tender_page id
    visit '/tenders/' + id + '/edit'
    self
  end
  
end