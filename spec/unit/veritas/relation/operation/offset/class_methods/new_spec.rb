require File.expand_path('../../../../../../../spec_helper', __FILE__)

describe 'Veritas::Relation::Operation::Offset.new' do
  before do
    @relation = Relation.new([ [ :id, Integer ] ], [ [ 1 ], [ 2 ] ])
  end

  subject { Relation::Operation::Offset.new(@relation, 1) }

  describe 'with an ordered relation' do
    before do
      @relation = @relation.order { |r| r[:id] }
    end

    it { should be_kind_of(Relation::Operation::Offset)  }
  end

  describe 'without an ordered relation' do
    it { method(:subject).should raise_error(OrderedRelationRequiredError, 'can only offset an ordered relation') }
  end
end
