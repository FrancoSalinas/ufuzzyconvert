module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'non_tabulated'

    class Triangular < NonTabulated

      PARAMETER_NUMBER = 3

      ##
      # Creates a triangular membership function.
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] x1
      #   The x-coordinate of the leftmost vertex.
      # @param [Numeric] x2
      #   The x-coordinate of the central vertex.
      # @param [Numeric] x3
      #   The x-coordinate of the rightmost vertex.
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When x1, x2 or x3 have invalid values.
      #
      def initialize(variable, x1, x2, x3, name = "")
        super(variable)

        if not x1.is_a? Numeric or not x2.is_a? Numeric or not x3.is_a? Numeric
          raise InputError.new, "Parameters must be numeric."
        end

        if x1 > x2 or x2 > x3
          raise InputError.new, "Parameters are not ordered."
        end

        @name = name
        @xs = [x1, x2, x2, x3]
      end
    end
  end
end
