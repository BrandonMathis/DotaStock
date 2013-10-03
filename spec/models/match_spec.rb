require 'spec_helper'
describe Match do
  describe '.from_json' do
    let(:json) { JSON.parse(Rails.root.join('spec', 'fixtures', 'package.json').read) }

    before do
      Match.from_json(json)
    end

    it 'will save proper information' do
      Match.count.should == 10
      PlayerMatch.count.should == 100
      Player.count.should == 34
      Hero.count.should == 49
    end

    it 'will track hero usage' do
      Hero.last.matches.count.should == 1
    end
  end
end
