# encoding: utf-8

describe Spatio::Parser::City do
  it { should respond_to :perform }

  it 'finds city' do
    FactoryGirl.create(:community, name: 'Berlin')
    subject.perform('Test in Berlin').should eq ['Berlin']
  end

  it 'works without city' do
    subject.perform('Foobar').should be_empty
  end
end
