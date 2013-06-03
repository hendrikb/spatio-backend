# encoding: utf-8
require 'spec_helper'

describe Spatio::ImportJob do
  subject { Spatio::ImportJob }
  it { should respond_to :perform }

  context '.perform' do
    let(:table_name) { 'test123s' }
    let(:import) { FactoryGirl.create :import, namespace: 'test123' }
    let(:n) { 20 }
    let(:reader_result) do
      result = []
      n.times { result << entry }
      result
    end

    before :each do
      mandatory_field_namespace = FactoryGirl.create :namespace, name: Namespace::MANDATORY_FIELD_NAMESPACE
      FactoryGirl.create :field, name: 'uuid', namespace: mandatory_field_namespace
      FactoryGirl.create :field, name: 'location', sql_type: 'GEOMETRY',namespace: mandatory_field_namespace
      import.setup_namespace
    end

    after :all do
      ActiveRecord::Base.connection.execute("DROP TABLE #{table_name}")
    end

    def entry
      {
        uuid: SecureRandom.base64,
        title: 'Foo Bar',
        location_string: 'Brandenburger Tor Berlin'
      }
    end

    it 'calls Importer for each entry' do
      Spatio::Reader::RSS.stub(:perform).and_return reader_result
      importer_mock = mock(perform: true)

      Spatio::Importer.should_receive(:new).exactly(n).times.and_return  importer_mock
      importer_mock.should_receive(:perform).exactly(n).times
      subject.perform import.id
    end

  end
end
