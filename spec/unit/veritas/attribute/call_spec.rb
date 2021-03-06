# encoding: utf-8

require 'spec_helper'

describe Attribute, '#call' do
  subject { object.call(tuple) }

  let(:described_class) { Attribute::Integer               }
  let(:object)          { described_class.new(:id)         }
  let(:header)          { Relation::Header.new([ object ]) }
  let(:tuple)           { Tuple.new(header, [ 1 ])         }

  it { should == 1 }
end
