require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe 'Veritas::Relation::Operation::Unary#optimize' do
  subject { unary_operation.optimize }

  let(:klass) { Class.new(UnaryOperationSpecs::Object) }

  context 'with an empty relation' do
    let(:empty)           { Relation::Empty.new([ [ :id, Integer ] ]) }
    let(:unary_operation) { klass.new(empty)                          }

    it { should equal(empty) }

    it 'returns an equivalent relation to the unoptimized operation' do
      should == unary_operation
    end

    it_should_behave_like 'an optimize method'
  end

  context 'with an non-empty relation' do
    let(:body)            { [ [ 1 ] ]                                }
    let(:relation)        { Relation.new([ [ :id, Integer ] ], body) }
    let(:unary_operation) { klass.new(relation)                      }

    it { should equal(unary_operation) }

    it 'does not execute body#each' do
      body.should_not_receive(:each)
      subject
    end

    it_should_behave_like 'an optimize method'
  end
end
