module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'non_tabulated'

    class Rectangular < NonTabulated

      #----------------------------[constants]---------------------------------#

      PARAMETER_NUMBER = 2

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

      ##
      # Creates a rectangular membership function.
      #
      # @param [Numeric] x1
      #   The left bound of the rectangle.
      # @param [Numeric] x2
      #   The right bound of the rectangle.
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When x1 or x2 have invalid values.
      #
      def initialize(x1, x2, name = "")
        if not x1.is_a? Numeric or not x2.is_a? Numeric
          raise InputError.new, "Parameters must be numeric."
        end

        if x1 > x2
          raise InputError.new, "Parameters are not ordered."
        end

        @name = name
        @xs = [x1, x1, x2, x2]
      end

      #----------------------------[public methods]----------------------------#

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
