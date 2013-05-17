require 'spec_helper'

describe Spatio::Geocode::Street do
  subject { Spatio::Geocode::Street }
  let(:street) { 'Turmstrasse' }
  let(:district) { 'Mitte'  }
  let(:city) { 'Berlin' }
  let(:coordinates) { [53, 11] }

  def location_string(*args)
    result = ""
    args.each { |arg| result = result + " #{arg}" }
    (result + " #{Spatio::Geocode::COUNTRY} ").strip
  end

  it { should respond_to :perform }

  it 'returns nil without streets' do
    Spatio::Geocode::Street.perform({ city: [city] }).should be nil
  end

  it 'calls Geocoder with street district and city' do
    Geocoder.should_receive(:coordinates).with(location_string(street, district, city)).
      and_return coordinates
    Spatio::Geocode::Street.perform({ streets: [street],
                                      districts: [district],
                                      cities: [city]})
  end

  it 'calls Geocoder with street city' do
    Geocoder.should_receive(:coordinates).with(location_string(street, city)).
      and_return coordinates
    Spatio::Geocode::Street.perform({ streets: [street],
                                      districts: [],
                                      cities: [city]})
  end

  it 'returns mercator point', :vcr do
    Spatio::Geocode::Street.perform({ streets: [street],
                                      districts: [],
                                      cities: [city]}).should be_kind_of RGeo::Geos::CAPIPointImpl


  end
end
