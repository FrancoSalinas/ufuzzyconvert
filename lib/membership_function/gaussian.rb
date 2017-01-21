module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'tabulated'

    class Gaussian < Tabulated

      #----------------------------[constants]---------------------------------#

      PARAMETER_NUMBER = 2

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

      ##
      # Creates a membership function which is equal to the difference of two
      # sigmoidal functions.
      #
      # $$f(x) = e^{-(x-c)^2 \over {2\sigma^2}}$$
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] sig
      # @param [Numeric] c
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When sig or c have invalid values.
      #
      def initialize(input_variable, sig, c, name = "")
        super(input_variable)

        if (
          not sig.is_a? Numeric or
          not c.is_a? Numeric
        )
          raise InputError.new, "Parameters must be numeric."
        end

        if 2 * sig ** 2 == 0
          raise InputError.new, "sig cannot be 0."
        end

        @name = name
        @sig = sig.to_f
        @c = c.to_f
      end

      #----------------------------[public methods]----------------------------#

      def evaluate(x)
        return Math.exp(-(x - @c) ** 2 / (2 * (@sig ** 2)))
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
