module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'non_tabulated'

    class Rectangular < NonTabulated

      PARAMETER_NUMBER = 2

      ##
      # Creates a rectangular membership function.
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] x1
      #   The left bound of the rectangle.
      # @param [Numeric] x2
      #   The right bound of the rectangle.
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When x1 or x2 have invalid values.
      #
      def initialize(input_variable, x1, x2, name = "")
        super(input_variable)

        if not x1.is_a? Numeric or not x2.is_a? Numeric
          raise InputError.new, "Parameters must be numeric."
        end

        if x1 > x2
          raise InputError.new, "Parameters are not ordered."
        end

        @name = name
        @xs = [x1, x1, x2, x2]
      end
    end
  end
end
