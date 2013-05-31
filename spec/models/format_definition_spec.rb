#encoding: utf-8
require 'spec_helper'

describe FormatDefinition do

  context 'fields' do
    it { should respond_to :name }
    it { should respond_to :importer_class }
    it { should respond_to :importer_parameters }
  end

  context 'validation' do
    it 'validates presence of name' do
      FactoryGirl.build(:format_definition, name: '').should_not be_valid
    end
    it 'validates presence of importer_class' do
      FactoryGirl.build(:format_definition, importer_class: '').should_not be_valid
    end
    it 'validates works correctly' do
      FactoryGirl.build(:format_definition).should be_valid
    end
  end

  context 'compatible?' do
    let(:importer_parameters) { { title_columns: ['title'], geo_columns: ['title'] } }

    it 'returns true if both meta_datas are empty' do
      format_definition = FactoryGirl.create(:format_definition,
                                             importer_parameters: importer_parameters)
      other_definition = FactoryGirl.create(:format_definition,
                                            name: 'foo',
                                            importer_parameters: importer_parameters)
      format_definition.compatible?(other_definition).should be true
    end

    it 'returns false with different meta_data' do
      format_definition = FactoryGirl.create(:format_definition,
                                             importer_parameters: importer_parameters)
      other_definition = FactoryGirl.create(:format_definition,
                                            name: 'foo',
                                            importer_parameters: importer_parameters.merge({ meta_data: { description: ['title'] } }))

      format_definition.compatible?(other_definition).should be false
    end

    it 'returns false with different meta_data' do
      format_definition = FactoryGirl.create(:format_definition,
                                             importer_parameters: importer_parameters.merge({ meta_data: { text: ['title'] } }))
      other_definition = FactoryGirl.create(:format_definition,
                                            name: 'foo',
                                            importer_parameters: importer_parameters.merge({ meta_data: { description: ['title'] } }))

      format_definition.compatible?(other_definition).should be false
    end

    it 'returns true with same meta_data keys' do
      format_definition = FactoryGirl.create(:format_definition,
                                             importer_parameters: importer_parameters.merge({ meta_data: { text: ['title'] } }))
      other_definition = FactoryGirl.create(:format_definition,
                                            name: 'foo',
                                            importer_parameters: importer_parameters.merge({ meta_data: { text: ['description'] } }))

      format_definition.compatible?(other_definition).should be true
    end

  end

  context '#reader_class' do
    it 'workds for RSS' do
      format_definition = FactoryGirl.create(:format_definition, importer_class: 'RSS')
      format_definition.reader_class.should eq Spatio::Reader::RSS
    end

    it 'raises error with XLS' do
      format_definition = FactoryGirl.create(:format_definition, importer_class: 'XLS')
      expect { format_definition.reader_class }.to raise_error
    end
  end

  context '#importer_parameters' do
    it 'is not valid without title_columns' do
      format_definition = FactoryGirl.build:format_definition,
        importer_parameters: { geo_columns: ['title'] }
      format_definition.should_not be_valid
    end

    it 'is not valid without geo_columns' do
      format_definition = FactoryGirl.build:format_definition,
        importer_parameters: { title_columns: ['title'] }
      format_definition.should_not be_valid
    end

    it 'cannot use article keyword without parse_articles' do
      format_definition = FactoryGirl.build:format_definition,
        importer_parameters: { title_columns: ['title', 'article'],
                               geo_columns: ['title'] }
        format_definition.should_not be_valid
    end

    it 'can use article keyword with parse_articles' do
      format_definition = FactoryGirl.build:format_definition,
        importer_parameters: { title_columns: ['title', 'article'],
                               geo_columns: ['title'],
                               parse_articles: true }
        format_definition.should be_valid
    end

    it 'cannot use article keyword in meta_data without flag' do
      format_definition = FactoryGirl.build:format_definition,
        importer_parameters: { title_columns: ['title'],
                               geo_columns: ['title'],
                               meta_data: { text: ['article'] } }
        format_definition.should_not be_valid
    end
  end
end
