module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'tabulated'

    class PiShaped < Tabulated

      #----------------------------[constants]---------------------------------#

      PARAMETER_NUMBER = 4

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

      ##
      # Creates a pi-shaped membership function.
      #
      # $$f(x) = \begin{cases}
      #  0 & x \le a \\
      #  2(\frac{x-a}{b-a})^2 & a \le x \le {{a + b} \over 2} \\
      #  1 - 2(\frac{x-b}{b-a})^2 & {{a + b} \over 2} \le x \le b \\
      #  1 & b \le x \le c \\
      #  1 - 2(\frac{x-c}{d-c})^2 & c \le x \le {{c + d} \over 2} \\
      #  2(\frac{x-d}{d-c})^2 & {{c + d} \over 2} \le x \le d \\
      #  0 & d \le x
      # \end{cases}$$
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] a
      #   x-coordinate where the slope starts growing.
      # @param [Numeric] b
      #   x-coordinate where the slope stops growing.
      # @param [Numeric] c
      #   x-coordinate where the slope starts falling.
      # @param [Numeric] d
      #   x-coordinate where the slope stops falling.
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When a, b, c or b have invalid values.
      #
      def initialize(input_variable, a, b, c, d, name = "")
        super(input_variable)

        if (
          not a.is_a? Numeric or
          not b.is_a? Numeric or
          not c.is_a? Numeric or
          not d.is_a? Numeric
        )
          raise InputError.new, "Parameters must be numeric."
        end

        if a >= b or b > c or c >= d
          raise InputError.new, "Parameters are not ordered."
        end

        @name = name
        @a = a.to_f
        @b = b.to_f
        @c = c.to_f
        @d = d.to_f
      end

      #----------------------------[public methods]----------------------------#

      def evaluate(x)
        if x < @a
          return 0
        end

        if x < (@a + @b) / 2
          return 2 * ((x - @a) / (@b - @a)) ** 2
        end

        if x < @b
          return 1 - 2 * ((x - @b) / (@b - @a)) ** 2
        end

        if x < @c
          return 1
        end

        if x < (@c + @d) / 2
          return 1 - 2 * ((x - @c) / (@d - @c)) ** 2
        end

        if x < @d
          return 2 * ((x - @d) / (@d - @c)) ** 2
        end

        return 0
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
