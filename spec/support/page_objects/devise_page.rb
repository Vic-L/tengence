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

end