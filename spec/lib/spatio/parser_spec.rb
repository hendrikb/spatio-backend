# encoding: utf-8

describe Spatio::Parser do
  context '.perform' do
    it 'calls Base.perform' do
      location_string = 'Musterstrasse 127 12345 Berlin'
      Spatio::Parser::Base.should_receive(:perform).
        with(location_string, 'Berlin').and_return 'Musterstrasse 127'
      subject.perform(location_string, 'Berlin')
    end
  end
end
