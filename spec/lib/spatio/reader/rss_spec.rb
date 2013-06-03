# encoding: utf-8

require 'spec_helper'

describe Spatio::Reader::RSS do
  subject { Spatio::Reader::RSS }

  it { should respond_to :perform }

  before :all do
    url = 'http://userpage.fu-berlin.de/rschaden/tests/rss_berlin_police_20.xml'
    @options = { url: url,
                geo_columns: ['title', 'article'],
                title_columns: ['title'],
                meta_data: { title: ['title'] },
                parse_articles: true,
                parse_articles_selector: '#bomain_content'}

    VCR.use_cassette "rss_test" do
      @result = Spatio::Reader::RSS.perform(@options)
    end
  end

  it 'has 20 entries' do
    @result.should have(20).entries
  end

  let(:title) { 'Körperverletzung in U-Bahnhof – Zeugen gesucht - Pankow' }
  let(:article) { 'Mit Bildern einer Überwachungskamera sucht die Polizei' }

  context 'location_string' do
    it 'includes title' do
      @result.first[:location_string].should include title
    end

    it 'parses and includes article' do
      @result.first[:location_string].should include article
    end
  end

  it 'sets correct title' do
    @result.first[:title].should eq title
  end

  context 'meta_data' do
    it 'sets title' do
      @result.first[:meta_data][:title].should eq title
    end
  end

  it 'sets an id' do
    @result.first[:id].should be_kind_of String
  end

  it 'falls back to empty string if loading link fails', :vcr do
    Net::HTTP.stub(:get).and_raise ArgumentError
    result = Spatio::Reader::RSS.perform(@options)
    result.first[:id].should be_kind_of String
  end
end
