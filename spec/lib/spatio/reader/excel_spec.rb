# encoding: utf-8

require 'spec_helper'

describe Spatio::Reader::Excel do
  subject { Spatio::Reader::Excel }

  it { should respond_to :perform }

  before :all do
    url = 'http://userpage.fu-berlin.de/rschaden/tests/wlan_20.xls'
    options = { url: url,
                geo_columns: [4, 5, 0, 6],
                title_columns: [1],
                meta_data: { cost_free: [7] } }

    VCR.use_cassette "xls_test" do
      @result = Spatio::Reader::Excel.perform(options)
    end
  end

  it 'has 20 entries' do
    @result.should have(20).entries
  end

  let(:street) { 'Fasanenstraße 75' }
  let(:district) { 'Charlottenburg' }
  let(:city) { 'Berlin' }
  let(:zipcode) { '10623' }
  let(:title_column) { 'Fasanenstraße 75 (vor BHI - Dresdner Bank)' }

  context 'location_string' do
    it 'includes street(4) column' do
      @result.first[:location_string].should include street
    end

    it 'includes district(0) column' do
      @result.first[:location_string].should include district
    end

    it 'includes zipcode(5) column' do
      @result.first[:location_string].should include zipcode
    end

    it 'includes city(6) column' do
      @result.first[:location_string].should include city
    end
  end

  it 'sets correct title' do
    @result.first[:title].should eq title_column
  end

  context 'meta_data' do
    it 'sets cosst_free' do
      @result.first[:meta_data][:cost_free].should eq 'J'
    end
  end
end
