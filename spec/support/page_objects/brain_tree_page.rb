class BrainTreePage
  include TendersPageFunctions

  def visit_subscribe_one_month_page
    visit '/subscribe-monthly'
    self
  end

  def visit_subscribe_three_months_page
    visit '/subscribe-quarterly'
    self
  end

  def visit_subscribe_one_year_page
    visit '/subscribe-annually'
    self
  end

  def visit_billing_page
    visit '/billing'
    self
  end

  def visit_plans_page
    visit '/plans'
    self
  end

  def visit_change_payment_page
    visit '/change-payment'
    self
  end

  # def visit_edit_payment_page
  #   visit '/edit-payment'
  #   self
  # end

  def visit_unsubscribe_page
    visit '/unsubscribe'
    self
  end

  def visit_payment_history_page
    visit '/payment-history'
    self
  end

  def valid_mastercard
    '5555555555554444'
  end

  def valid_visa
    '4111111111111111'
  end

  def invalid_mastercard
    '5105105105105100'
  end

  def invalid_visa
    '4000111111111115'
  end

  # def valid_maestro
  #   '6304000000000000'
  # end

  def valid_cvv
    '123'
  end

  def unverified_cvv
    '201'
  end

  def unmatched_cvv
    '200'
  end

  # def non_participating_issuer_cvv
  #   '301'
  # end

end