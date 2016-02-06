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

# every :day, :at => local('7am'), :tz => 'Asia/Singapore' do
#   rake "emailer:schedule_send_keywords_tenders_emails"
# end

every :day, :at => local('7am'), :tz => 'Asia/Singapore' do
  rake "maintenance:remove_trial_tenders"
  rake "maintenance:cleanup_past_tenders"
end