# encoding: utf-8

describe Spatio::Parser do
  context '.perform' do
    it 'calls Base.perform' do
      location_string = 'Musterstrasse 127 12345 Berlin'
      Spatio::Parser::Base.should_receive(:perform).
        with(location_string).and_return 'Musterstrasse 127'
      subject.perform(location_string).should eq 'Musterstrasse 127'
    end
  end
end
