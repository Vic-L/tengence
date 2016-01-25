class KeywordsTendersPage
  include Capybara::DSL
  
  def visit_page
    visit '/keywords_tenders'
    self
  end

  def update_keywords
    find('#submit').click
  end

  def add_1_keyword
    fill_in 'keywords', with: Faker::Lorem.word
  end

  def add_2_keywords
    fill_in 'keywords', with: "#{Faker::Lorem.word},#{Faker::Lorem.word}"
  end

  def add_too_many_keywords number
    array = []
    21.times do
      array << Faker::Lorem.word
    end
    fill_in 'keywords', with: array.join(',')
  end
end
