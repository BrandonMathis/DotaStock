require Rails.root.join 'lib', 'dota_api'
require Rails.root.join 'lib', 'collector'

desc "get last 100 matches"
task :get_matches, [:matches] => [:environment] do |t, args|
  limit =  (args[:matches] || "25").to_i
  Collector.get_matches(limit)
end

desc "Collect Matches until last known match_id"
task :update_match_history => [:environment] do |t, args|
  last_match = Match.order("match_id").last.match_id
  ap "Collecting Matches Till #{last_match}"
  Collector.get_matches_till(last_match)
end

desc "populate hero information"
task :get_hero_information => :environment do
  heros_json = DotaAPI.get_heroes
  heros_json.map{ |h| HashWithIndifferentAccess.new(h)}.each do |json_hero|
    hero = Hero.find_or_create_by_hero_id(json_hero[:id].to_s)
    hero.localized_name = json_hero[:localized_name]
    hero.name = json_hero[:name]
    hero.save
  end
end

task :start_collector => :environment do
  Collector.start
  %x[script/delayed_job start]
end

task :stop_collector do
  %x[script/delayed_job stop]
end
