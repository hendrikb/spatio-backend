# encoding: utf-8

describe Spatio::Parser::Base do
  subject { Spatio::Parser::Base }

  context '.perform' do
    let(:location_string) { 'Musterstrasse 127 abc Berlin' }

    it 'calls Streets.perform' do
      Spatio::Parser::Street.should_receive(:perform).with(location_string)
      subject.perform(location_string)
    end

    it 'returns a hash with street set' do
      street = 'Musterstrasse'
      Spatio::Parser::Street.stub(:perform).and_return street
      subject.perform(location_string)[:street].should eq street
    end

    it 'calls City.perform' do
      Spatio::Parser::City.should_receive(:perform).with(location_string)
      subject.perform(location_string)
    end

    it 'returns a hash with city set' do
      city = 'Berlin'
      Spatio::Parser::City.stub(:perform).and_return city
      subject.perform(location_string)[:city].should eq city
    end
  end
end
