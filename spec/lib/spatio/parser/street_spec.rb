# encoding: utf-8

describe Spatio::Parser::Street do
  subject { Spatio::Parser::Street }
  context '.perform' do
    STREETS = ['Alexanderplatz', 'Kurfürstendamm', 'Turmstr']

    context 'other streets' do
      STREETS.each do |street|
        it "matches #{street} in roads table" do
          FactoryGirl.create :road, name: street
          subject.perform(street).should include street
        end
      end
    end

    context 'multiple streets' do
      it 'returns multiple streets' do
        first_street = 'Turmstrasse'
        second_street = 'Beusselstrasse'
        FactoryGirl.create :road, name: first_street
        FactoryGirl.create :road, name: second_street
        subject.perform("#{first_street}/#{second_street}").should =~ [first_street, second_street]
      end
    end
  end
end
