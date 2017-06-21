module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'tabulated'

    class BellShaped < Tabulated

      PARAMETER_NUMBER = 3

      ##
      # Creates a generalized bell-shaped membership function.
      #
      # `f(x) = 1 / (1+|(x-c)/a|^(2b))`
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] a
      # @param [Numeric] b
      # @param [Numeric] c
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When a, b or c have invalid values.
      #
      def initialize(variable, a, b, c, name = "")
        super(variable)

        if (
          not a.is_a? Numeric or
          not b.is_a? Numeric or
          not c.is_a? Numeric
        )
          raise InputError.new, "Parameters must be numeric."
        end

        if a == 0
          raise InputError.new, "a cannot be 0."
        end

        @name = name
        @a = a.to_f
        @b = b.to_f
        @c = c.to_f
      end

      def evaluate(x)
        return 1 / (1 + ((x - @c) / @a).abs ** (2 * @b))
      end
    end
  end
end
