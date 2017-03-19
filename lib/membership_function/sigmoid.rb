module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'tabulated'

    class Sigmoid < Tabulated

      PARAMETER_NUMBER = 2

      ##
      # Creates a sigmoidal membership function.
      #
      # $$f(x) = 1 \over {1+e^{-a(x-c)}}$$
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] a
      # @param [Numeric] c
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When a or c have invalid values.
      #
      def initialize(variable, a, c, name = "")
        super(variable)

        if (
          not a.is_a? Numeric or
          not c.is_a? Numeric
        )
          raise InputError.new, "Parameters must be numeric."
        end

        @name = name
        @a = a.to_f
        @c = c.to_f
      end

      def evaluate(x)
        return 1 / (1 + Math.exp(-@a * (x - @c)))
      end
    end
  end
end
