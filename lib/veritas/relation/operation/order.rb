# encoding: utf-8

module Veritas
  class Relation
    module Operation

      # A class representing a sorted relation
      class Order < Relation
        include Unary

        # The relation sort order
        #
        # @return [Operation::Order::DirectionSet]
        #
        # @api private
        attr_reader :directions

        # Instantiate a new Order
        #
        # @example
        #   order = Order.new(operand, directions)
        #
        # @param [Relation] operand
        #   the relation to sort
        # @param [DirectionSet, Array<Direction, Attribute>] directions
        #   the directions to sort tuples in
        #
        # @return [Order]
        #
        # @api public
        def self.new(operand, directions)
          directions = DirectionSet.coerce(directions)
          assert_order_by_full_header(operand, directions)
          super
        end

        # Assert the full header is sorted on
        #
        # Sorting on the full header ensures deterministic results,
        # which is necessary for ordering to be useful.
        #
        # @param [Relation] operand
        # @param [#attributes] directions
        #
        # @return [undefined]
        #
        # @raise [InvalidDirectionsError]
        #   raised if the full header is not sorted on
        #
        # @api private
        def self.assert_order_by_full_header(operand, directions)
          if operand.header.to_set != directions.attributes.to_set
            raise InvalidDirectionsError, 'directions must include every attribute in the header'
          end
        end

        private_class_method :assert_order_by_full_header

        # Initialize an Order
        #
        # @param [Relation] operand
        #   the relation to sort
        # @param [DirectionSet, Array<Direction, Attribute>] directions
        #   the directions to sort tuples in
        #
        # @return [undefined]
        #
        # @api private
        def initialize(operand, directions)
          super(operand)
          @directions = directions
        end

        # Iterate over each tuple in the set
        #
        # @example
        #   order = Order.new(operand, directions)
        #   order.each { |tuple| ... }
        #
        # @yield [tuple]
        #
        # @yieldparam [Tuple] tuple
        #   each tuple in the set
        #
        # @return [self]
        #
        # @api public
        def each
          return to_enum unless block_given?
          directions.sort_tuples(operand).each { |tuple| yield tuple }
          self
        end

        # Compare the Order with other relation for equality
        #
        # @example
        #   order.eql?(other)  # => true or false
        #
        # @param [Relation] other
        #   the other relation to compare with
        #
        # @return [Boolean]
        #
        # @api public
        def eql?(other)
          super && directions.eql?(other.directions)
        end

        # Return the hash of the order
        #
        # @example
        #   hash = order.hash
        #
        # @return [Fixnum]
        #
        # @api public
        def hash
          super ^ directions.hash
        end

        module Methods

          # Return an ordered relation
          #
          # @example
          #   order = relation.sort_by { |r| [ r.a.desc, r.b ] }
          #
          # @yield [relation]
          #   optional block to evaluate for directions
          #
          # @yieldparam [Relation] relation
          #
          # @yieldreturn [Array<Direction>, Header]
          #
          # @return [Order]
          #
          # @api public
          def sort_by
            context = Evaluator::Context.new(header) { |context| yield context }
            Order.new(self, Array(context.yield))
          end

          # Return an ordered relation (Deprecated)
          #
          # @deprecated Use #sort_by instead
          #
          # @example with no directions
          #   order = relation.order  # sort by the header
          #
          # @example with a block
          #   order = relation.order { |r| [ r.a.desc, r.b ] }
          #
          # @yield [relation]
          #   optional block to evaluate for directions
          #
          # @yieldparam [Relation] relation
          #
          # @yieldreturn [Array<Direction>, Header]
          #
          # @return [Order]
          #
          # @api public
          def order
            warn "#{self.class}#order is deprecated and will be removed from Veritas 0.0.6"
            sort_by { |context| block_given? ? yield(context) : header }
          end

        end # module Methods

        Relation.class_eval { include Methods }

        memoize :hash

      end # class Order
    end # module Operation
  end # class Relation
end # module Veritas
