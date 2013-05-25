require 'spec_helper'

describe Namespace do
  context 'fields' do
    let(:namespace) { FactoryGirl.create :namespace }
    let!(:mandatory_field_namespace) do
      FactoryGirl.create :namespace,
        name: Namespace::MANDATORY_FIELD_NAMESPACE
    end

    it 'includes custom fields' do
      field = FactoryGirl.create :field, namespace: namespace
      namespace.all_fields.should include field
    end

    it 'includes mandatory fields' do
      field = FactoryGirl.create :field, namespace: mandatory_field_namespace

      namespace.all_fields.should include field
    end
  end
end
