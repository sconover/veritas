require 'spec_helper'

describe 'Veritas::Relation::Operation::Limit#optimize' do
  subject { object.optimize }

  let(:klass)      { Relation::Operation::Limit               }
  let(:body)       { [ [ 1 ], [ 2 ], [ 3 ] ].each             }
  let(:relation)   { Relation.new([ [ :id, Integer ] ], body) }
  let(:directions) { [ relation[:id] ]                        }
  let(:order)      { relation.order(directions)               }
  let(:operand)    { order                                    }
  let(:limit)      { 1                                        }
  let(:object)     { klass.new(operand, limit)                }

  context 'when the limit is 0' do
    let(:limit) { 0 }

    it { should be_kind_of(Relation::Empty) }

    it 'returns an equivalent relation to the unoptimized operation' do
      should == object
    end

    it 'does not execute body#each' do
      body.should_not_receive(:each)
      subject
    end

    it_should_behave_like 'an optimize method'
  end

  context 'containing an order operation' do
    it { should equal(object) }

    it 'does not execute body#each' do
      body.should_not_receive(:each)
      subject
    end

    it_should_behave_like 'an optimize method'
  end

  context 'containing an optimizable order operation' do
    let(:operand) { order.project(order.header) }

    it { should be_instance_of(klass) }

    its(:operand) { should equal(order) }

    its(:to_i) { should == 1 }

    it 'returns an equivalent relation to the unoptimized operation' do
      should == object
    end

    it 'does not execute body#each' do
      body.should_not_receive(:each)
      subject
    end

    it_should_behave_like 'an optimize method'
  end

  context 'containing a more restrictive object operation' do
    let(:operand) { order.limit(5) }
    let(:limit)   { 10             }

    it { should be_instance_of(klass) }

    its(:operand) { should equal(order) }

    it 'uses the more restrictive object' do
      subject.to_i.should == 5
    end

    it 'returns an equivalent relation to the unoptimized operation' do
      should == object
    end

    it 'does not execute body#each' do
      body.should_not_receive(:each)
      subject
    end

    it_should_behave_like 'an optimize method'
  end

  context 'containing a less restrictive object operation' do
    let(:operand) { order.limit(10) }
    let(:limit)   { 5               }

    it { should be_instance_of(klass) }

    its(:operand) { should equal(order) }

    it 'uses the more restrictive object' do
      subject.to_i.should == 5
    end

    it 'returns an equivalent relation to the unoptimized operation' do
      should == object
    end

    it 'does not execute body#each' do
      body.should_not_receive(:each)
      subject
    end

    it_should_behave_like 'an optimize method'
  end

  context 'containing a similar object operation' do
    let(:operand) { order.limit(10) }
    let(:limit)   { 10              }

    it { should equal(operand) }

    it 'returns an equivalent relation to the unoptimized operation' do
      should == object
    end

    it 'does not execute body#each' do
      body.should_not_receive(:each)
      subject
    end

    it_should_behave_like 'an optimize method'
  end

  context 'containing a materialized relation' do
    let(:relation) { Relation.new([ [ :id, Integer ] ], [ [ 1 ], [ 2 ], [ 3 ] ]) }

    it { should eql(Relation::Materialized.new([ [ :id, Integer ] ], [ [ 1 ] ])) }

    it 'returns an equivalent relation to the unoptimized operation' do
      should == object
    end

    it_should_behave_like 'an optimize method'
  end
end