# encoding: utf-8

require 'spec_helper'

describe Function::Numeric::Exponentiation, '#inverse' do
  subject { object.inverse }

  let(:object) { described_class.new(left, right) }
  let(:left)   { 2                                }
  let(:right)  { 2                                }

  it_should_behave_like 'an idempotent method'

  it { should be_kind_of(Function::Numeric::Exponentiation) }

  its(:left)  { should equal(left)                                    }
  its(:right) { should eql(Function::Numeric::Division.new(1, right)) }
end
