env :PATH, ENV['PATH']

every 15.minutes do
  rake 'update_match_history'
end
