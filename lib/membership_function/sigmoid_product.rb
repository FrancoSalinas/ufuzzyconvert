module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'tabulated'

    class SigmoidProduct < Tabulated

      PARAMETER_NUMBER = 4

      ##
      # Creates a membership function which is equal to the product of two
      # sigmoidal functions.
      #
      # $$f(x) = {1 \over {1+e^{-a_1(x-c_1)}}} {1 \over {1+e^{-a_2(x-c_2)}}}$$
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] a1
      # @param [Numeric] c1
      # @param [Numeric] a2
      # @param [Numeric] c2
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When a1, c1, a2 or c2 have invalid values.
      #
      def initialize(input_variable, a1, c1, a2, c2, name = "")
        super(input_variable)

        if (
          not a1.is_a? Numeric or
          not c1.is_a? Numeric or
          not a2.is_a? Numeric or
          not c2.is_a? Numeric
        )
          raise InputError.new, "Parameters must be numeric."
        end

        @name = name
        @a1 = a1.to_f
        @c1 = c1.to_f
        @a2 = a2.to_f
        @c2 = c2.to_f
      end

      def evaluate(x)
        s1 = 1 / (1 + Math.exp(-@a1 * (x - @c1)))
        s2 = 1 / (1 + Math.exp(-@a2 * (x - @c2)))
        return s1 * s2
      end
    end
  end
end
