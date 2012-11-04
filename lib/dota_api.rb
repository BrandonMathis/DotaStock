require 'net/http'
require 'json'
require 'yaml'

class DotaAPI
  KEY = YAML.load(File.read(Rails.root.join('config', 'api_config.yml')))['key']
  # GET_MATCH_HISTORY = "https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/"
  GET_MATCH_HISTORY = "https://api.steampowered.com/IDOTA2Match_205790/GetMatchHistory/V001/"
  GET_HEROES = "http://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/"

  class << self
    def collect_match_starting_at(match_id, opts = nil)
      json = JSON.parse(make_ssl_request(GET_MATCH_HISTORY, {start_at_match_id: match_id}.merge(opts)).body)
    end

    def get_last_25
      JSON.parse(make_ssl_request(GET_MATCH_HISTORY).body)
    end

    def get_matches(limit, starting_match_id = nil)
      return [] if limit <= 0
      opts = (limit < 25)? {matches_requested: limit} : {}
      opts.merge!({start_at_match_id: starting_match_id}) if starting_match_id
      
      matches = JSON.parse(make_ssl_request(GET_MATCH_HISTORY, opts).body)
      matches = HashWithIndifferentAccess.new(matches)[:result][:matches]
      matches = matches.uniq{|match| match[:match_id]}

      limit  -= matches.count
      starting_match_id = matches.last[:match_id]

      matches.concat get_matches(limit, starting_match_id)
    end

    #add params and key using something in net http
    def make_ssl_request(request_uri, params = {})
      request_uri = build_request_uri(request_uri, params)
      ap request_uri
      uri = URI.parse(request_uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
    end

    def make_request(request_uri, params = {})
      request_uri = build_request_uri(request_uri, params)
      ap request_uri
      uri = URI.parse(request_uri)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
    end

    def extract_match_ids(matches)
      match_ids = matches.map { |match| match['match_id'] }
    end

    def get_heroes
      JSON.parse(make_request(GET_HEROES, {language: 'en_us'}).body)['result']['heroes']
    end

    private
    def build_request_uri(uri, params = {})
      params.delete_if { |k, v| v.blank? }
      params.merge!({ key: KEY })
      params = params.collect { |key, value| "#{key.to_s}=#{value}" }.join('&')
      uri + '?' + params
    end
  end
end
