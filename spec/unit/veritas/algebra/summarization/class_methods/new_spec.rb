# encoding: utf-8

require 'spec_helper'

describe Algebra::Summarization, '.new' do
  subject { object.new(operand, summarize_per, summarizers) }

  let(:header)      { [ [ :id, Integer ] ]                   }
  let(:operand)     { Relation.new(header, [ [ 1 ], [ 2 ] ]) }
  let(:summarizers) { {}                                     }
  let(:object)      { described_class                        }

  context 'with a summarize_per that has a subset of the headers in the operand' do
    let(:summarize_per) { TABLE_DEE }

    it { should be_kind_of(object) }
  end

  context 'with a summarize_per that has equivalent headers to the headers in the operand' do
    let(:summarize_per) { operand }

    specify { expect { subject }.to raise_error(InvalidHeaderError, 'the summarize_per header must be a proper subset of the operand header') }
  end

  context 'with a summarize_per that has a superset of the headers in the operand' do
    let(:summarize_per) { Relation.new([ [ :id, Integer ], [ :name, String ] ], [ [ 1, 'Dan Kubb' ] ]) }

    specify { expect { subject }.to raise_error(InvalidHeaderError, 'the summarize_per header must be a proper subset of the operand header') }
  end
end
