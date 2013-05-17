require 'spec_helper'

describe Spatio::Geocode::Street do
  subject { Spatio::Geocode::Street }
  it { should respond_to :perform }
end
