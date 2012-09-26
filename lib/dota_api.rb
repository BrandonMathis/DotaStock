require 'net/http'
require 'json'
require 'yaml'

class DotaAPI
  KEY = YAML.load(File.read(Rails.root.join('config', 'api_config.yml')))['key']
  # GET_MATCH_HISTORY = "https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/"
  GET_MATCH_HISTORY = "https://api.steampowered.com/IDOTA2Match_205790/GetMatchHistory/V001/"

  def self.collect_match_starting_at(match_id, opts = nil)
    json = JSON.parse(make_request(GET_MATCH_HISTORY, {start_at_match_id: match_id}.merge(opts)).body)
  end

  def self.get_last_25
    JSON.parse(make_request(GET_MATCH_HISTORY).body)
  end

  def self.get_matches(limit)
    total_matches = []
    matches = get_last_25
    total_matches.concat matches['result']['matches']
    while(total_matches.count < limit) do
      last_match_id = total_matches.last['match_id']
      matches_requested = ((matches_remaining = limit - total_matches.count) >= 25)? {} : {matches_requested: matches_remaining + 1} # must +1 bc get_matches will also return the last_match_id match
      result = collect_match_starting_at(last_match_id, matches_requested)['result']['matches']
      collected_match_ids = extract_match_ids(total_matches)
      result.reject! { |match| collected_match_ids.include? match['match_id'] }
      total_matches.concat(result)
    end
    return total_matches
  end

  #add params and key using something in net http
  def self.make_request(request_uri, params = {})
    params.delete_if { |k, v| v.blank? }
    params.merge!({ key: KEY })
    params = params.collect { |key, value| "#{key.to_s}=#{value}" }.join('&')
    request_uri = request_uri + '?' + params
    ap request_uri
    uri = URI.parse(request_uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
  end

  def self.extract_match_ids(matches)
    match_ids = matches.map { |match| match['match_id'] }
  end
end
