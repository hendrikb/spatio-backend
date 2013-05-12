require 'spec_helper'

describe Spatio::Parser::State do
  it { should respond_to :perform }

  it 'finds state' do
    FactoryGirl.create(:state, name: 'Bayern')
    subject.perform('Test in Bayern').should eq ['Bayern']
  end

  it 'works without state' do
    subject.perform('Foobar').should be_empty
  end
end
