require 'spec_helper'

describe 'Veritas::Logic::Predicate::GreaterThan#complement' do
  subject { greater_than.complement }

  let(:attribute)    { Attribute::Integer.new(:id) }
  let(:greater_than) { attribute.gt(1)             }

  it { should eql(attribute.lte(1)) }

  it 'is reversible' do
    subject.complement.should equal(greater_than)
  end

  it_should_behave_like 'an idempotent method'
end
