# encoding: utf-8

require 'spec_helper'

describe Function::Numeric::UnaryPlus, '.inverse' do
  subject { object.inverse }

  let(:object) { described_class }

  it { should equal(Function::Numeric::UnaryMinus) }
end
