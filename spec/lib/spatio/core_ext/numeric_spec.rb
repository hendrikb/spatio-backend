require 'spec_helper'

describe Numeric do
  context '#duration' do
    it 'returns seconds' do
      (42.5).duration.should eq '42 seconds'
    end

    it 'returns minutes and seconds' do
      317.duration.should eq '5 minutes and 17 seconds'
    end

    it 'returns hours and minutes' do
      7334.duration.should eq '2 hours and 2 minutes'
    end
  end
end
