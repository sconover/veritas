require 'spec_helper'

describe Function::Predicate::Inequality, '.reverse' do
  subject { object.reverse }

  let(:object) { described_class }

  it { should equal(Function::Predicate::Inequality) }
end