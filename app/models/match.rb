class Match < ActiveRecord::Base
  # Lobby Types
  {
    5 => 'Team match',
    4 => 'Co-op with bots',
    3 => 'Tutorial',
    2 => 'Tournament',
    1 => 'Practice',
    0 => 'Public matchmaking',
   -1 => 'Invalid'
  }

  has_many :player_matches, primary_key: :match_id
  has_many :players, through: :player_matches

  has_many :hero_matches
  has_many :heros, through: :hero_matches

  validates_uniqueness_of :match_id

  def self.from_json(json)
    json = HashWithIndifferentAccess.new(json)
    json[:matches].each do |match_json|
      match = Match.new(
        match_id: match_json[:match_id],
        match_seq_num: match_json[:match_seq_num],
        start_time: DateTime.strptime(match_json[:start_time].to_s,'%s'),
        lobby_type: match_json[:lobby_type].to_i
       )
       if match.save
         match_json[:players].each do |player_json|
           player = Player.find_or_create_by_account_id(player_json[:account_id].to_s)
           hero = Hero.find_or_create_by_hero_id(hero_id: player_json[:hero_id].to_i, name: 'UNDEFINED')
           PlayerMatch.create(
             player_id: player.id,
             hero_id: hero.hero_id,
             match_id: match.id,
             player_slot: player_json[:player_slot]
           )
         end
       else
         next
       end
    end
  end
end
