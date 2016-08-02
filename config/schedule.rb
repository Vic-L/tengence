# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
require "tzinfo"

def local(time)
  TZInfo::Timezone.get("Asia/Singapore").local_to_utc(Time.parse(time))
end

every :day, :at => local('2pm'), :tz => 'Asia/Singapore' do
  rake "emailer:schedule_send_keywords_tenders_emails"
end

every :day, :at => local('7am'), :tz => 'Asia/Singapore' do
  rake "maintenance:cleanup_past_tenders"
  rake "maintenance:refresh_cache"
  rake "maintenance:subscription_ending_reminder"
  rake "maintenance:charge_users"
end

every '0 0 1 * *' do
  rake "maintenance:remove_trial_tenders"
end

every 10.minutes do
  rake 'maintenance:ping_sidekiq'
end