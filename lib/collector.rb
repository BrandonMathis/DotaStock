require Rails.root.join 'lib', 'dota_api'

class Collector
  def collect_matches
    last_match = Match.order("match_id").last.match_id
    Collector.get_matches_till(last_match)
    self.delay(:run_at => 10.seconds.from_now).collect_matches
  end

  def self.start
    new.collect_matches
  end

  def self.get_matches_till(last_saved_match_id, start_at_match_id = nil)
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

  def self.get_matches(limit = 100, start_at_match_id = nil)
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
end
