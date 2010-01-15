require 'set'

require 'veritas/support/abstract_class'

require 'veritas/relation'
require 'veritas/algebra'

require 'veritas/attribute'
require 'veritas/tuple'
require 'veritas/version'

module Veritas
  class InvalidHeaderError < ArgumentError; end

  class OrderedRelationRequiredError < StandardError; end
end
