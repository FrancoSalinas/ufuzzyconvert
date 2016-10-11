module UFuzzyConvert

  require_relative '../exception'
  require_relative '../fixed_point'

  module MembershipFunction

    class NonTabulated

      #----------------------------[constants]---------------------------------#

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

      #----------------------------[public methods]----------------------------#

      ##
      # Converts the membership function into a CFS array.
      #
      # @param [Numeric] range_min
      #   The minimum value that the variable is able to take.
      # @param [Numeric] range_max
      #   The maximum value that the variable is able to take.
      # @param [Hash<Symbol>] options
      #   This parameter is ignored.
      # @return [Array<Integer>]
      #   Returns the membership function converted to CFS format.
      #
      def to_cfs(range_min, range_max, options = nil)
        if not range_min.is_a? Numeric
          raise InputError.new, "Range lower bound must be a number."
        end

        if not range_max.is_a? Numeric
          raise InputError.new, "Range upper bound must be a number."
        end

        if range_max <= range_min
          raise InputError.new, "Range bounds are swapped."
        end

        return @xs.map {
          |x| x.to_cfs(range_min, range_max)
        }.flatten
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
