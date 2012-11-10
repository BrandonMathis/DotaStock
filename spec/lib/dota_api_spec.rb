require 'spec_helper'
require Rails.root.join 'lib', 'dota_api'
describe DotaAPI do
  describe '#get_matches' do
    it 'gives a limited number of matches' do
      DotaAPI.get_matches(25).count.should eql 25
    end
  end
end