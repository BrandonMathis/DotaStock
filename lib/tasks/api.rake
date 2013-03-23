require Rails.root.join 'lib', 'dota_api'

desc "get last 25 matches"
task :get_matches, [:matches] => [:environment] do |t, args|
  ap limit =  (args[:matches] || "25").to_i
  result = DotaAPI.get_matches(limit)
  ap DotaAPI.extract_match_ids(result)
  save_matches(result)
end

task :update_match_history => [:environment] do |t, args|
  last_match = Match.order("match_id").last.match_id
  ap "Collecting Matches Till #{last_match}"
  result = DotaAPI.get_matches_till(last_match)
  ap DotaAPI.extract_match_ids(result)
  save_matches(result)
end

desc "populate hero information"
task :get_hero_information => :environment do
  heros_json = DotaAPI.get_heroes
  heros_json.each do |json_hero|
    hero = Hero.find_or_create_by_hero_id(json_hero['id'])
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

def save_matches(json)
  json.each do |json_match|
    next if json_match['players'].blank?
    match = Match.create(match_id: json_match['match_id'])
    next if match.invalid?
    json_match['players'].each do |json_player|
      player = match.players.create(account_id: json_player['account_id'])
      player.hero = Hero.find_or_create_by_hero_id(json_player['hero_id'].to_s)
      player.save
    end
  end
end
