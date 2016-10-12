module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'tabulated'

    class ZShaped < Tabulated

      #----------------------------[constants]---------------------------------#

      PARAMETER_NUMBER = 2

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

      ##
      # Creates a z-shaped membership function.
      #
      # $$f(x) = \begin{cases}
      #  1 & x \le a \\
      #  1 - 2(\frac{x-a}{b-a})^2 & a \le x \le {{a + b} \over 2} \\
      #  2(\frac{x-b}{b-a})^2 & {{a + b} \over 2} \le x \le b \\
      #  0 & b \le x
      # \end{cases}$$
      #
      # @param [Numeric] a
      #   x-coordinate where the slope starts.
      # @param [Numeric] b
      #   x-coordinate where the slope ends.
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When a or b have invalid values.
      #
      def initialize(a, b, name = "")
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

      #----------------------------[public methods]----------------------------#

      def evaluate(x)
        if x < @a
          return 1
        end

        if x < (@a + @b) / 2
          return 1 - 2 * ((x - @a) / (@b - @a)) ** 2
        end

        if x < @b
          return 2 * ((x - @b) / (@b - @a)) ** 2
        end

        return 0
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
