module UFuzzyConvert

  require_relative '../exception'
  require_relative '../fixed_point'

  module MembershipFunction

    require_relative 'base'

    class NonTabulated < Base

      #----------------------------[constants]---------------------------------#

      CFS_TYPE = 0

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

      ##
      # Creates a non-tabulated membership function.
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      #
      def initialize input_variable
        super
      end

      #----------------------------[public methods]----------------------------#

      ##
      # Converts the membership function into a CFS array.
      #
      # @param [Hash<Symbol>] options
      #   This parameter is ignored.
      # @return [Array<Integer>]
      #   Returns the membership function converted to CFS format.
      #
      def to_cfs(options = nil)

        cfs_data = [CFS_TYPE, 0]

        range_min = @variable.range_min
        range_max = @variable.range_max

        @xs.each do |x|
          cfs_data.concat x.to_cfs(range_min, range_max, false)
        end

        return cfs_data
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
