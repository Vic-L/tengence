module WaitForPageLoad
  def wait_for_page_load
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until page.has_css?('.mask', visible: false)
      sleep 2
    end
  end
end
