module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'tabulated'

    class TwoSidedGaussian < Tabulated

      #----------------------------[constants]---------------------------------#

      PARAMETER_NUMBER = 4

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

      ##
      # Creates a membership function which is defined by two gaussian functions
      # .`sig1` and `c1` define the leftmost part of the curve, while `sig2` and
      # `c2` define the rightmost part of the curve. If `c1 < c2` then the
      # function evaluates to `1`  when `c1 < x < c2`. Otherwise the function
      # evaluates to the product of both gaussian functions.
      #
      # $$f_1(x) = \begin{cases}
      #   e^{-(x-c_1)^2 \over {2\sigma_1^2}} & x \le c_1 \\
      #   1 & c_1 \lt x
      # \end{cases}$$

      # $$f_2(x) = \begin{cases}
      #   e^{-(x-c_2)^2 \over {2\sigma_2^2}} & x \le c_2 \\
      #   1 & c_2 \lt x
      # \end{cases}$$
      #
      # $$f(x) = f_1(x) f_2(x)$$
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] sig1
      # @param [Numeric] c1
      # @param [Numeric] sig2
      # @param [Numeric] c2
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When sig1, c1, sig2 or c2 have invalid values.
      #
      def initialize(input_variable, sig1, c1, sig2, c2, name = "")
        super(input_variable)

        if (
          not sig1.is_a? Numeric or
          not c1.is_a? Numeric or
          not sig2.is_a? Numeric or
          not c2.is_a? Numeric
        )
          raise InputError.new, "Parameters must be numeric."
        end

        if 2 * sig1 ** 2 == 0
          raise InputError.new, "sig1 cannot be 0."
        end

        if 2 * sig2 ** 2 == 0
          raise InputError.new, "sig2 cannot be 0."
        end

        @name = name
        @sig1 = sig1.to_f
        @c1 = c1.to_f
        @sig2 = sig2.to_f
        @c2 = c2.to_f
      end

      #----------------------------[public methods]----------------------------#

      def evaluate(x)
        if x < @c1
          g1 = Math.exp(-(x - @c1) ** 2 / (2 * @sig1 ** 2))
        else
          g1 = 1
        end

        if x > @c2
          g2 = Math.exp(-(x - @c2) ** 2 / (2 * @sig2 ** 2))
        else
          g2 = 1
        end
        return g1 * g2
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
