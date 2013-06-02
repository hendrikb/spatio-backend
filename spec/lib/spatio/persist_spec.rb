# encoding: utf-8

require 'spec_helper'

describe Spatio::Persist do
  it { should respond_to :perform }

  context '.perform' do
    let(:table_name) { 'test123s' }

    before :each do
      mandatory_field_namespace = FactoryGirl.create :namespace, name: Namespace::MANDATORY_FIELD_NAMESPACE
      FactoryGirl.create :field, name: 'uuid', namespace: mandatory_field_namespace
      FactoryGirl.create :field, name: 'location', sql_type: 'GEOMETRY',namespace: mandatory_field_namespace
    end

    after :all do
      ActiveRecord::Base.connection.execute("DROP TABLE #{table_name}")
    end

    def row_count
      ActiveRecord::Base.connection.select_one("SELECT COUNT(*) FROM #{table_name}")["count"].to_i
    end

    it 'works with table created by setup_namespace' do
      import = FactoryGirl.create(:import, namespace: 'test123')
      import.setup_namespace

      data = { uuid: 'ABC1234', location: create_area }
      expect { subject.perform(table_name, data) }.to change { row_count }.by(1)
    end
  end
end
