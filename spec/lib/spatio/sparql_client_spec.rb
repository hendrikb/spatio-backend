require 'spec_helper'

describe Spatio::SparqlClient do
  context 'states' do
    it 'includes Berlin', :vcr do
      subject.states.should include 'Berlin'
    end

    it 'has 16 entries', :vcr do
      subject.states.should have(16).entries
    end
  end

  context 'cities' do
    it 'includes Ulm', :vcr do
      subject.cities.should include 'Ulm'
    end

    it 'has more than 100 entries', :vcr do
      subject.cities.size.should > 100
    end

    it 'does not include Lists', :vcr do
      subject.cities.grep(/Liste/).should be_empty
    end

    ['Berlin', 'Hamburg', 'Bremen'].each do |city_state|
      it "includes #{city_state}", :vcr do
        subject.cities.should include city_state
      end
    end
  end
end
