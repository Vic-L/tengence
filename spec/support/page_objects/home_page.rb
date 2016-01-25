class HomePage
  include Capybara::DSL

  def visit_page
    visit '/'
    # visit '/register'
    self
  end

  def submit_demo_email_request
    execute_script("$('.email-demo-submit-button')[0].scrollIntoView(false);")
    execute_script("$('.email-demo-submit-button').click();")
  end

  def fill_up_demo_email_form
    execute_script("$('#agree')[0].scrollIntoView(false);")
    fill_in 'demo_email', with: Faker::Internet.email
    check 'agree'
  end
end