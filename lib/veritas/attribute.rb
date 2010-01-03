module Veritas
  class Attribute
    include Comparable

    attr_reader :name, :type

    def initialize(name, type)
      @name, @type = name.to_sym, type
    end

    def rename(name)
      self.class.new(name, type)
    end

    def <=>(other)
      other = self.class.coerce(other)
      [ name.to_s, type ] <=> [ other.name.to_s, other.type ]
    end

    def eql?(other)
      instance_of?(other.class) &&
      name.eql?(other.name) &&
      type.eql?(other.type)
    end

    def hash
      name.hash ^ type.hash
    end

    def self.coerce(attribute)
      attribute.kind_of?(Attribute) ? attribute : new(*attribute)
    end

    def self.name_from(attribute)
      if attribute.kind_of?(Attribute)
        attribute.name
      elsif attribute.respond_to?(:to_ary)
        attribute.to_ary.first
      else
        attribute.to_sym
      end
    end

  end # class Attribute
end # module Veritas