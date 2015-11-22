require Rails.root.join('lib', 'rails_admin', 'send_emailer_now.rb')
require Rails.root.join('lib', 'rails_admin', 'send_test_mailer.rb')
require Rails.root.join('lib', 'rails_admin', 'toggle_access_level.rb')

RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::SendEmailerNow)
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::SendTestMailer)
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ToggleAccessLevel)

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete

    send_emailer_now              #custom for user only
    send_test_mailer              #custom for user only
    toggle_access_level           #toggle access level

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
