require Rails.root.join 'lib', 'dota_api'

desc "get last 25 matches"
task :get_matches => :environment do
  result = DotaAPI.get_matches(100)
  ap DotaAPI.extract_match_ids(result)

  result.each do |json_match|
    next if json_match['players'].blank?
    match = Match.create(match_id: json_match['match_id'])
    next if match.invalid?
    json_match['players'].each do |json_player|
      player = match.players.create(account_id: json_player['account_id'])
      player.hero = Hero.find_or_create_by_hero_id(json_player['hero_id'])
      player.save
    end
  end
end

desc "populate hero information"
task :get_hero_information => :environment do
  heros_json = DotaAPI.get_heroes
  heros_json.each do |json_hero|
    hero = Hero.find_or_create_by_hero_id(json_hero['id'])
    ap hero
    hero.name = json_hero['localized_name']
    hero.save
  end
end
