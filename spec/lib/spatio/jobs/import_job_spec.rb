# encoding: utf-8
require 'spec_helper'

describe Spatio::ImportJob do
  subject { Spatio::ImportJob }
  it { should respond_to :perform }
end
