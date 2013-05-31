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
end
