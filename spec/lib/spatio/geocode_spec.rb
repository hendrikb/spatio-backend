require 'spec_helper'

describe Spatio::Geocode do
  it { should respond_to :perform }

  context '.perform' do
    it 'returns Street result if present' do
      locations = 'Brandenburger Tor Berlin'
      street_result = Spatio::GEOFACTORY.point(13,52)

      Spatio::Geocode::Street.should_receive(:perform).with(locations).and_return street_result
      subject.perform(locations).should eq street_result
    end

    it 'returns OsmData result otherwise' do
      locations = 'Berlin Mitte'
      osm_result = create_area

      Spatio::Geocode::Street.stub(:perform)
      Spatio::Geocode::OsmData.should_receive(:perform).with(locations).and_return osm_result
      subject.perform(locations).should eq osm_result
    end
  end
end
