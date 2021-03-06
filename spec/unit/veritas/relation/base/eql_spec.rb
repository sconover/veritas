# encoding: utf-8

require 'spec_helper'

describe Relation::Base, '#eql?' do
  subject { object.eql?(other) }

  let(:name)   { 'users'.freeze                          }
  let(:header) { [ [ :id, Integer ] ]                    }
  let(:body)   { [ [ 1 ] ].each                          }
  let(:object) { described_class.new(name, header, body) }

  before do
    object.should be_instance_of(described_class)
  end

  context 'with the same object' do
    let(:other) { object }

    it { should be(true) }

    it 'is symmetric' do
      should == other.eql?(object)
    end
  end

  context 'with an equivalent object' do
    let(:other) { object.dup }

    it { should be(true) }

    it 'is symmetric' do
      should == other.eql?(object)
    end
  end

  context 'with an equivalent object of a subclass' do
    let(:other) { Class.new(described_class).new(name, header, body) }

    it { should be(false) }

    it 'is symmetric' do
      should == other.eql?(object)
    end
  end

  context 'with an object having a different name' do
    let(:other_name)   { 'other_users'.freeze                                      }
    let(:other_header) { header                                                    }
    let(:other_body)   { body                                                      }
    let(:other)        { described_class.new(other_name, other_header, other_body) }

    it { should be(false) }

    it 'is symmetric' do
      should == other.eql?(object)
    end
  end

  context 'with an object having a different header' do
    let(:other_name)   { name                                                      }
    let(:other_header) { [ [ :id, Numeric ] ]                                      }
    let(:other_body)   { body                                                      }
    let(:other)        { described_class.new(other_name, other_header, other_body) }

    it { should be(false) }

    it 'is symmetric' do
      should == other.eql?(object)
    end
  end

  context 'with an object having a different body' do
    let(:other_name)   { name                                                      }
    let(:other_header) { header                                                    }
    let(:other_body)   { [ [ 2 ] ].each                                            }
    let(:other)        { described_class.new(other_name, other_header, other_body) }

    it { should be(false) }

    it 'is symmetric' do
      should == other.eql?(object)
    end
  end

  context 'with an object having an equivalent header in a different order' do
    let(:attribute1) { [ :id,   Integer ]                                             }
    let(:attribute2) { [ :name, String  ]                                             }
    let(:header1)    { [ attribute1, attribute2 ]                                     }
    let(:header2)    { [ attribute2, attribute1 ]                                     }
    let(:object)     { described_class.new(name, header1, [ [ 1, 'Dan Kubb' ] ].each) }
    let(:other)      { described_class.new(name, header2, [ [ 'Dan Kubb', 1 ] ].each) }

    it { should be(true) }

    it 'is symmetric' do
      should == other.eql?(object)
    end
  end
end
