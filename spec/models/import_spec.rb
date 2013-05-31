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
  end
end
