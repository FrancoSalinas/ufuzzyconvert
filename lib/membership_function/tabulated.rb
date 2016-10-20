module UFuzzyConvert

  require_relative '../exception'
  require_relative '../fixed_point'

  module MembershipFunction

    class Tabulated

      #----------------------------[constants]---------------------------------#

      CFS_TYPE = 1
      
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
      # @option options [Integer] :tsize
      #   Base 2 logarithm of the number of entries in a tabulated membership
      #   function.
      # @return [Array<Integer>]
      #   Returns the membership function converted to CFS format.
      #
      def to_cfs(range_min, range_max, options)
        if not range_min.is_a? Numeric
          raise InputError.new, "Range lower bound must be a number."
        end

        if not range_max.is_a? Numeric
          raise InputError.new, "Range upper bound must be a number."
        end

        if range_max <= range_min
          raise InputError.new, "Range bounds are swapped."
        end

        if not options[:tsize].is_a? Integer
          raise InputError.new, "options[:tsize] must be integer."
        end

        if options[:tsize] > 16
          raise InputError.new, "options[:tsize] must be less or equal to 16."
        end

        table_size = 1 << options[:tsize]

        membership_function = [CFS_TYPE, options[:tsize]]

        delta = range_max - range_min
        for index in 0...table_size
          x = range_min + (index + 0.5) * delta / table_size
          membership_function.push(*evaluate(x).to_cfs(0, 1))
        end

        return membership_function
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
