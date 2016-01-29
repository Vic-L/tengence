class DevisePage
  include Capybara::DSL

  def visit_login_page
    visit '/users/sign_in'
    self
  end

  def visit_user_sign_up_page
    visit '/users/sign_up'
    self
  end

  def visit_register_page
    visit '/register'
    self
  end

  def visit_vendor_registration_page
    visit '/organizations/register'
    self
  end

  def visit_edit_page
    visit '/users/edit'
    self
  end

  def visit_user_confirmation_page
    visit '/users/confirmation/new'
    self
  end

  def visit_new_password_page
    visit '/users/password/new'
    self
  end

  def submit_form
    execute_script("$('#submit').click()")
  end

  def click_logout
    execute_script("$('#navigation li:last-child a').click()")
  end

  def fill_up_registration_form
    fill_in 'user_first_name', with: Faker::Name.first_name
    fill_in 'user_last_name', with: Faker::Name.last_name
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_company_name', with: Faker::Company.name
    fill_in 'user_password', with: Faker::Internet.password(8)
    check('eula')
  end

  def fill_up_login_form email, password
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
  end

end