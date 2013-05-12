require 'spec_helper'

describe Spatio::Parser::District do
  it { should respond_to :perform }


  context 'district in right city' do
    let(:city) { FactoryGirl.create(:community) }
    let!(:district) { FactoryGirl.create(:district, name: 'Mitte', community: city) }

    it 'finds district' do
      subject.perform('Test in Mitte', city.name).should eq ['Mitte']
    end

    it 'finds multiple districts' do
      FactoryGirl.create(:district, name: 'Pankow', community: city)
      subject.perform('Test in Pankow/Mitte', city.name).should =~ ['Mitte', 'Pankow']
    end
  end

  it 'ignores district of other cities' do
    city = FactoryGirl.create(:community)
    other_city = FactoryGirl.create(:community, name: 'Hamburg')
    FactoryGirl.create(:district, name: 'Mitte', community: other_city)

    subject.perform('Test in Mitte', city.name).should be_empty
  end

  it 'does not fail with non existing city' do
    expect { subject.perform('Test in Mitte', 'Test123') }.not_to raise_error
  end
end
