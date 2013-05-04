# encoding: utf-8

describe Spatio::Parser::Street do
  subject { Spatio::Parser::Street }
  context '.perform' do
    context 'fixed streets' do
      ['Adlergestell', 'Unter den Linden'].each do |fixed_street|
        it "matches #{fixed_street}" do
          subject.perform(fixed_street).should include fixed_street
        end
      end
    end
    STREETS = ['Alexanderplatz', 'Kurfürstendamm', 'Turmstr',
               'Tegeler Straße', 'Friedrichsstrasse', 'Hackescher Markt',
               'Gendarmenmarkt', 'Kottbusser Tor', 'Strasse des 17. Juni',
               'Allee der Kosmonauten', 'Karl-Marx-Allee', 'Alte Hamburger Strasse',
               'Görlitzer Park', 'Alt-Moabit'
    ]
    context 'other streets' do
      STREETS.each do |street|
        it "matches #{street}" do
          subject.perform(street).should include street
        end
      end
    end

    context 'other places' do
      ['Gehweg', 'Parkplatz'].each do |place|
        it "does not match #{place}" do
          subject.perform(place).should_not include place
        end
      end
    end

    context 'multiple streets' do
      it 'returns multiple streets' do
        subject.perform('Turmstr/Beusselstr').should eq ['Turmstr', 'Beusselstr']
      end
    end
  end
end
