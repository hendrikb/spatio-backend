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
end
