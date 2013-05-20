# encoding: utf-8

require 'spec_helper'

describe Spatio::Persist do
  it { should respond_to :perform }

  it 'works with states' do
    data = { name: 'Berlin' }
    expect { subject.perform('states', data) }.to change { State.count }.by(1)
  end
end
