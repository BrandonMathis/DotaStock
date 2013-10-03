require Rails.root.join 'lib', 'dota_api'

desc "get last 100 matches"
task :get_matches, [:matches] => [:environment] do |t, args|
  limit =  (args[:matches] || "25").to_i
  get_matches(limit)
end

desc "Collect Matches until last known match_id"
task :update_match_history => [:environment] do |t, args|
  last_match = Match.order("match_id").last.match_id
  ap "Collecting Matches Till #{last_match}"
  result = DotaAPI.get_matches_till(last_match)
end

desc "populate hero information"
task :get_hero_information => :environment do
  heros_json = DotaAPI.get_heroes
  heros_json.each do |json_hero|
    hero = Hero.find_or_create_by_hero_id(json_hero['id'].to_s)
    hero.name = json_hero['localized_name']
    hero.save
  end
end

desc "repopulate hero information" 
task :reload_hero_information => :environment do
  Match.delete_all
  Player.delete_all
  Rake::Task["get_matches"].execute
end

def get_matches_till(last_saved_match_id, start_at_match_id = nil)
  result = DotaAPI.get_match_history(start_at_match_id: start_at_match_id)
  matches = result[:result][:matches]
  return if result[:result][:results_remaining] == 0
  if matches.blank?
    sleep 10
    get_matches_till(last_saved_match_id, start_at_match_id)
  end
  prune = false
  matches.delete_if do |match|
    prune = true if match[:match_id].to_s == last_saved_match_id
    prune
  end
  Match.from_json(matches)
  return if prune
  return if matches.blank?
  get_matches_till(last_saved_match_id, matches.last["match_id"])
end

def get_matches(limit = 100, start_at_match_id = nil)
  return if limit <= 0
  result = DotaAPI.get_match_history(matches_requested: limit, start_at_match_id: start_at_match_id)
  matches = result[:result][:matches]
  return if result[:result][:results_remaining] == 0
  if matches.blank?
    sleep 20
    get_matches limit, start_at_match_id
  end
  limit -= matches.count if limit
  Match.from_json(matches)
  get_matches(limit, matches.last["match_id"])
end
