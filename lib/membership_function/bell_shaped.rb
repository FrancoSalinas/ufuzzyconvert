module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'tabulated'

    class BellShaped < Tabulated

      #----------------------------[constants]---------------------------------#

      PARAMETER_NUMBER = 3

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

      ##
      # Creates a generalized bell-shaped membership function.
      #
      # $$f(x) = \frac{1}{1+|\frac{x-c}{a}|^{2b}}$$
      #
      # @param [Numeric] a
      # @param [Numeric] b
      # @param [Numeric] c
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When a, b or c have invalid values.
      #
      def initialize(a, b, c, name = "")
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
        @a = a
        @b = b
        @c = c
      end

      #----------------------------[public methods]----------------------------#

      def evaluate(x)
        return 1.0 / (1 + ((x - @c) / @a).abs ** (2 * @b))
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
