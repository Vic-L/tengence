class PostTenderPage
  include Capybara::DSL
  include TendersPageFunctions
  
  def visit_page
    visit '/tenders/new'
    self
  end

  def find_css selector
    page.driver.find_css selector
  end
  
  def upload_file id,file_path
    attach_file id, file_path
  end

  def upload_2_files_then_remove_first
    id = find_css('fieldset').first.find_css("input[type='file']").first['id']
    attach_file id, "#{Rails.root}/Gemfile"

    find('a.add-upload').click

    id = find_css('fieldset').last.find_css("input[type='file']").first['id']
    attach_file id, "#{Rails.root}/Capfile"
    
    find_css('.remove-upload').first.click
  end

  def upload_2_files
    id = find_css('fieldset').first.find_css("input[type='file']").first['id']
    attach_file id, "#{Rails.root}/Gemfile"

    find('a.add-upload').click

    id = find_css('fieldset').last.find_css("input[type='file']").first['id']
    attach_file id, "#{Rails.root}/Capfile"
  end

  def upload_blank_file
    find('a.add-upload').click
  end
end