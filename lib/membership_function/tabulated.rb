module UFuzzyConvert

  require_relative '../exception'
  require_relative '../fixed_point'

  module MembershipFunction

    require_relative 'base'

    class Tabulated < Base

      #----------------------------[constants]---------------------------------#

      CFS_TYPE = 1

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

      ##
      # Creates a tabulated membership function.
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      #
      def initialize(input_variable)
        super
      end

      #----------------------------[public methods]----------------------------#

      ##
      # Converts the membership function into a CFS array.
      #
      # @param [Hash<Symbol>] options
      # @option options [Integer] :tsize
      #   Base 2 logarithm of the number of entries in a tabulated membership
      #   function.
      # @return [Array<Integer>]
      #   Returns the membership function converted to CFS format.
      #
      def to_cfs(options)

        if not options[:tsize].is_a? Integer
          raise InputError.new, "options[:tsize] must be integer."
        end

        if options[:tsize] > 16
          raise InputError.new, "options[:tsize] must be less or equal to 16."
        end

        table_size = 1 << options[:tsize]

        membership_function = [CFS_TYPE, options[:tsize]]

        range_min = @variable.range_min
        range_max = @variable.range_max

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
