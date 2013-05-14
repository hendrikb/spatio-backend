require 'spec_helper'

describe Spatio::Geocode::OsmData do
  subject { Spatio::Geocode::OsmData }

  it { should respond_to :perform }

  context 'districts' do
    it 'finds right district' do
      district = FactoryGirl.create(:district, name: 'Mitte', area: create_area)
      subject.perform({ districts: ['Mitte'], cities: ['Berlin']}).should eq district.area
    end

    it 'does not raise without district in database' do
      expect do
        subject.perform({ districts: ['Mitte'], cities: ['Berlin']})
      end.not_to raise_error
    end
  end

  context 'cities' do
    it 'finds right city' do
      city = FactoryGirl.create(:community, name: 'Berlin', area: create_area)
      subject.perform({ cities: ['Berlin']}).should eq city.area
    end
  end
end
