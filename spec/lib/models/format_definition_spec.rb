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
        FormatDefinition.create(importer_class: 'TestClass').save.should be_false
    end
    it 'validates presence of importer_class' do
        FormatDefinition.create(name: 'TestName').save.should be_false
    end
    it 'validates works correctly' do
        FormatDefinition.create(name: 'TestName', importer_class: 'TC').save.should be_true
    end
  end

  context 'valid_namespace?' do
    let(:namespace) { 'osc_berlin' }

    it 'returns true if namespace is present' do
      FactoryGirl.create(:format_definition, name: namespace)
      FormatDefinition.valid_namespace?(namespace).should be true
    end

    it 'returns false if namespace is not present' do
      FormatDefinition.valid_namespace?(namespace).should be false
    end
  end
end
