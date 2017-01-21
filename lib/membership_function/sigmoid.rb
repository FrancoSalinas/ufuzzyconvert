module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'tabulated'

    class Sigmoid < Tabulated

      #----------------------------[constants]---------------------------------#

      PARAMETER_NUMBER = 2

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

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
      def initialize(input_variable, a, c, name = "")
        super(input_variable)

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

      #----------------------------[public methods]----------------------------#

      def evaluate(x)
        return 1 / (1 + Math.exp(-@a * (x - @c)))
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
