require 'spec_helper'

describe Import do
  context 'validations' do
    context 'compatibility_in_namespace' do

      it 'is valid without other import' do
        FactoryGirl.build(:import).should be_valid
      end

      it 'is valid without other import with same namespace' do
        (1..5).each do |i|
          FactoryGirl.create(:import, namespace: "namespace#{i}")
        end
        FactoryGirl.build(:import, namespace: "foo").should be_valid
      end

      it 'is not valid if format_definitions are not compatible' do
        FactoryGirl.create(:import)
        FormatDefinition.any_instance.stub(compatible?: false)
        FactoryGirl.build(:import).should_not be_valid
      end
    end

    context '#setup_namespace' do
      let(:table_name) { 'test123s' }

      before :each do
        mandatory_field_namespace = FactoryGirl.create :namespace, name: Namespace::MANDATORY_FIELD_NAMESPACE
        FactoryGirl.create :field, name: 'uuid', namespace: mandatory_field_namespace
        FactoryGirl.create :field, name: 'location', sql_type: 'GEOMETRY',namespace: mandatory_field_namespace
      end

      after :all do
        ActiveRecord::Base.connection.execute("DROP TABLE #{table_name}")
      end

      it 'creates table' do
        import = FactoryGirl.create(:import, namespace: 'test123')
        import.setup_namespace
        ActiveRecord::Base.connection.tables.should include table_name
      end
    end

    context '#create_fields' do
      let(:importer_parameters) do
        { title_columns: ["title"],
          geo_columns: "title",
          meta_data: { description: ["title"] } }
      end

      it 'creates field for entry in metadata' do
        format_definition = FactoryGirl.create(:format_definition,
                                              importer_parameters: importer_parameters)
        import = FactoryGirl.create(:import, format_definition: format_definition)
        expect { import.create_fields('test123') }.to change { Field.count }.by(1)
      end

    end
  end
end
