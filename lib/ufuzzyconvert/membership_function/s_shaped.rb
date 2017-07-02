module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'tabulated'

    class SShaped < Tabulated

      PARAMETER_NUMBER = 2

      ##
      # Creates a s-shaped membership function.
      #
      # `
      # f(x) = {
      # (0, if x le a text(,)),
      # (2 ((x-a)/(b-a))^2, if a le x le (a+b)/2 text(,)),
      # (1 - 2((x-b)/(b-a))^2, if (a+b)/2 le x le b text(,)),
      # (1, if x ge b)
      # :}
      # `
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] a
      #   x-coordinate where the slope starts.
      # @param [Numeric] b
      #   x-coordinate where the slope ends.
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When a or b have invalid values.
      #
      def initialize(variable, a, b, name = "")
        super(variable)

        if (
          not a.is_a? Numeric or
          not b.is_a? Numeric
        )
          raise InputError.new, "Parameters must be numeric."
        end

        if a >= b
          raise InputError.new, "a must be lower than b."
        end

        @name = name
        @a = a.to_f
        @b = b.to_f
      end

      def evaluate(x)
        if x < @a
          return 0
        end

        if x < (@a + @b) / 2.0
          return 2 * ((x - @a) / (@b - @a)) ** 2
        end

        if x < @b
          return 1 - 2 * ((x - @b) / (@b - @a)) ** 2
        end

        return 1
      end
    end
  end
end
