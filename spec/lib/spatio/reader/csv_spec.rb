# encoding: utf-8

require 'spec_helper'

describe Spatio::Reader::CSV do
  subject { Spatio::Reader::CSV }

  it { should respond_to :perform }

  before :all do
    url = 'http://userpage.fu-berlin.de/rschaden/tests/osc_raw_crimes_20.csv'
    options = { url: url,
                geo_columns: [1, 4],
                title_columns: [1],
                meta_data: { title: [1] },
                col_sep: ';' }

    VCR.use_cassette "csv_test" do
      @result = Spatio::Reader::CSV.perform(options)
    end
  end

  it 'has 20 entries' do
    @result.should have(20).entries
  end

  let(:title_column) { 'Treffer - Reinickendorf' }
  let(:text_column) { 'Den richtigen Riecher hatten in der vergangen Nacht Polizeibeamte' }

  context 'location_string' do
    it 'includes title(1) column' do
      @result.first[:location_string].should include title_column
    end

    it 'includes text(4) column' do
      @result.first[:location_string].should include text_column
    end
  end

  it 'sets correct title' do
    @result.first[:title].should eq title_column
  end

  context 'meta_data' do
    it 'sets title' do
      @result.first[:meta_data][:title].should eq title_column
    end
  end

  it 'sets an id' do
    @result.first[:id].should be_kind_of String
  end

end
