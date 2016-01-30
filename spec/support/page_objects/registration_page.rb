class RegistrationPage
  include Capybara::DSL
  include TendersPageFunctions

  def visit_read_only_users_registration_page
    visit '/users/sign_up'
    # visit '/register'
    self
  end

  def visit_write_only_users_registration_page
    visit '/organizations/register'
    self
  end

  def fill_up_form
    fill_in 'user_first_name', with: Faker::Name.first_name
    fill_in 'user_last_name', with: Faker::Name.last_name
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_company_name', with: Faker::Company.name
    fill_in 'user_password', with: Faker::Internet.password(8)
    check('eula')
  end
end