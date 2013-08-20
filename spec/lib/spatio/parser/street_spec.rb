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
      let(:first_street) { 'Turmstrasse' }
      let(:second_street) { 'Beusselstrasse' }

      before do
        FactoryGirl.create :road, name: first_street
        FactoryGirl.create :road, name: second_street
      end

      it 'returns multiple streets' do
        subject.perform("#{first_street}/#{second_street}").should =~ [first_street, second_street]
      end

      it 'prioritizes streetnames with street number' do
        subject.perform("#{first_street} und #{second_street} 123").first.
          should == "#{second_street} 123"
      end
    end
  end
end
