module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'non_tabulated'

    class Trapezoidal < NonTabulated

      #----------------------------[constants]---------------------------------#

      PARAMETER_NUMBER = 4

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

      ##
      # Creates a trapezoidal membership function.
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] x1
      #   The x-coordinate of the first vertex.
      # @param [Numeric] x2
      #   The x-coordinate of the second vertex.
      # @param [Numeric] x3
      #   The x-coordinate of the third vertex.
      # @param [Numeric] x4
      #   The x-coordinate of the fourth vertex.
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When x1, x2, x3 or x4 have invalid values.
      #
      def initialize(input_variable, x1, x2, x3, x4, name = "")
        super(input_variable)

        if (
          not x1.is_a? Numeric or
          not x2.is_a? Numeric or
          not x3.is_a? Numeric or
          not x4.is_a? Numeric
        )
          raise InputError.new, "Parameters must be numeric."
        end

        if x1 > x2 or x2 > x3 or x3 > x4
          raise InputError.new, "Parameters are not ordered."
        end

        @name = name
        @xs = [x1, x2, x3, x4]
      end

      #----------------------------[public methods]----------------------------#

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
