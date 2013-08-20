# encoding: utf-8

require 'spec_helper'

describe Spatio::Importer do
  let(:id) { 'ABC' }
  let(:title) { 'Foobar' }
  let(:location_string) { 'Brandenburger Tor Mitte' }

  let(:entry) { { id: id, title: title, location_string: location_string} }
  let(:namespace) { FactoryGirl.create(:namespace) }
  let(:geo_context) { 'Berlin' }
  let(:berlin_coords) { { lat: 13.354949, lon: 52.540802  } }

  context 'skip geocoding if coords are given' do
    subject do
      Spatio::Importer.new(entry,
                           namespace, nil, berlin_coords)
    end

    it 'preserves given coordinates' do
      location = Spatio::GEOFACTORY.point(berlin_coords[:lat], berlin_coords[:lon])
      subject.perform
      subject.entry[:location].should eq location
    end
  end

  context 'perform' do
    subject { Spatio::Importer.new(entry, namespace, geo_context) }
    it 'calls Parser.perform' do
      Spatio::Geocode.stub(:perform)
      Spatio::Persist.stub(:perform)

      Spatio::Parser.should_receive(:perform).with(location_string, geo_context)
      subject.perform
    end

    it 'calls Geocode with result of Parser' do
      Spatio::Persist.stub(:perform)
      location_hash = { state: ['Berlin'], city: ['Berlin'],
                        district: ['Mitte'], street: ['Pariser Platz']}
      Spatio::Parser.stub(:perform).and_return location_hash

      Spatio::Geocode.should_receive(:perform).with(location_hash)
      subject.perform
    end

    it 'calls persist with right table and arguments' do
      location = create_area
      Spatio::Parser.stub(:perform)
      Spatio::Geocode.stub(:perform).and_return location

      time = DateTime.now
      DateTime.stub(:now).and_return time
      data = { uuid: id, title: title, location: location, created_at: time }

      Spatio::Persist.should_receive(:perform).with(namespace.table_name, data)
      subject.perform
    end

    context 'error handling' do
      before do
        Spatio::Parser.stub(:perform)
        Spatio::Geocode.stub(:perform).and_return create_area
      end

      it 'logs a warning without location' do
        Spatio::Persist.stub(:perform).and_raise Spatio::NoLocationError

        LOG.should_receive(:warn).with("Could not find location: #{title}")
        subject.perform
      end

      it 'logs an error with other error' do
        Spatio::Persist.stub(:perform).and_raise ArgumentError

        LOG.should_receive(:error).with("Could not save: #{title}")
        subject.perform
      end
    end
  end

end
