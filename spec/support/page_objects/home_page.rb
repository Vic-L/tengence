class HomePage
  include TendersPageFunctions

  def visit_page
    visit '/'
    # visit '/register'
    self
  end

  # sources and counting
  def reveal_all_sources
    execute_script("$('#show-all')[0].scrollIntoView(false);")
    execute_script("$('#show-all').click();")
    sleep 3
  end

  def fill_up_demo_email_form
    execute_script("$('#email-demo-submit-button')[0].scrollIntoView(false);")
    fill_in 'demo_email', with: Faker::Internet.email
    check 'agree'
  end

  # contacts
  def fill_up_contacts_form
    fill_in 'name', with: Faker::Name.name
    fill_in 'contact_email', with: Faker::Internet.email
    fill_in 'comments', with: Faker::Lorem.sentences(5).join(" ")
  end

  def submit_contacts_form
    execute_script("$('#submit')[0].scrollIntoView(false);")
    execute_script("$('#submit').click();")
  end
end