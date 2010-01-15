require File.expand_path('../../../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe 'Veritas::Relation::Operation::Binary#right' do
  before do
    @left  = Relation.new([ [ :id,   Integer ] ], [ [ 1 ] ])
    @right = Relation.new([ [ :name, String  ] ], [ [ 'Dan Kubb' ] ])

    @binary_operation = BinaryOperationSpecs::Object.new(@left, @right)
  end

  subject { @binary_operation.right }

  it { should equal(@right) }
end