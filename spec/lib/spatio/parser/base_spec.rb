# encoding: utf-8

describe Spatio::Parser::Base do
  subject { Spatio::Parser::Base }

  context '.perform' do
    let(:location_string) { 'Musterstrasse 127 abc Berlin' }
    let(:city) { 'Ulm' }

    it 'calls Streets.perform' do
      Spatio::Parser::Street.should_receive(:perform).with(location_string)
      subject.perform(location_string)
    end

    it 'returns a hash with streets set' do
      street = 'Musterstrasse'
      Spatio::Parser::Street.stub(:perform).and_return [street]
      subject.perform(location_string)[:streets].should eq [street]
    end

    it 'calls City.perform' do
      Spatio::Parser::City.should_receive(:perform).with(location_string)
      subject.perform(location_string)
    end

    it 'returns a hash with cities set' do
      Spatio::Parser::City.stub(:perform).and_return [city]
      subject.perform(location_string)[:cities].should eq [city]
    end

    it 'calls District.perform with city' do
      Spatio::Parser::City.stub(:perform).and_return [city]
      Spatio::Parser::District.should_receive(:perform).with(location_string, [city])
      subject.perform(location_string)
    end

    it 'calls State.perform' do
      Spatio::Parser::State.should_receive(:perform).with(location_string)
      subject.perform(location_string)
    end

    context 'context resolution' do
      it 'correctly sets city' do
        Spatio::Parser::City.should_receive(:perform).with(city).and_return [city]
        subject.perform('Musterstrasse', city)[:cities].should eq [city]
      end

      it 'correctly sets state' do
        state = 'Bayern'
        Spatio::Parser::State.should_receive(:perform).with(state).and_return [state]
        subject.perform('Musterstrasse', state)[:states].should eq [state]
      end

      it 'sets both state and city for Berlin' do
        city = 'Berlin'
        Spatio::Parser::State.should_receive(:perform).with(city).and_return [city]
        Spatio::Parser::City.should_receive(:perform).with(city).and_return [city]
        result = subject.perform('Musterstrasse', city)

        result[:states].should eq [city]
        result[:cities].should eq [city]
      end
    end
  end
end
