# encoding: utf-8

require 'spec_helper'

describe Tuple, '#to_ary' do
  subject { object.to_ary }

  let(:header) { Relation::Header.new([ [ :id, Integer ] ]) }
  let(:object) { described_class.new(header, [ 1 ])         }

  it_should_behave_like 'an idempotent method'

  it { should be_kind_of(Array) }

  it { should be_frozen }

  it { should == [ 1 ] }
end
