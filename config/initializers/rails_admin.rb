require Rails.root.join('lib', 'rails_admin', 'send_emailer_now.rb')
require Rails.root.join('lib', 'rails_admin', 'send_test_mailer.rb')
require Rails.root.join('lib', 'rails_admin', 'toggle_access_level.rb')
require Rails.root.join('lib', 'rails_admin', 'send_emailers_now.rb')

RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::SendEmailerNow)
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::SendTestMailer)
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ToggleAccessLevel)
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::OneDayAgo)
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::TwoDayAgo)
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ThreeDayAgo)
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::FourDayAgo)
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::FiveDayAgo)

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
    one_day_ago
    two_day_ago
    three_day_ago
    four_day_ago
    five_day_ago
    index                         # mandatory
    new do
      except ['CurrentTender','CurrentPostedTender', 'PastTender','PastPostedTender']
    end
    export
    bulk_delete do
      except ['CurrentTender','CurrentPostedTender', 'PastTender','PastPostedTender']
    end
    show
    edit do
      except ['CurrentTender','CurrentPostedTender', 'PastTender','PastPostedTender']
    end
    delete  do
      except ['CurrentTender','CurrentPostedTender', 'PastTender','PastPostedTender']
    end

    send_emailer_now              #custom for user only
    send_test_mailer              #custom for user only
    toggle_access_level           #toggle access level

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
