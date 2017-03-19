module UFuzzyConvert

  require_relative '../exception'
  require_relative '../fixed_point'

  module MembershipFunction

    require_relative 'base'

    ##
    # Class used to represent any membership function.
    #
    # This class is used by {Proposition} to represent a proposition that does
    # not affect a variable, i.e. 'INPUT IS ANY'
    #
    class Constant < Base

      PARAMETER_NUMBER = 1

      ##
      # Creates a constant membership function.
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] constant
      #   A constant value.
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When constant has an invalid value.
      #
      def initialize(variable, constant, name = "")
        super(variable)

        if not constant.is_a? Numeric
          raise InputError.new, "Parameters must be numeric."
        end

        @name = name
        @constant = constant
      end

      ##
      # Converts the membership function into a CFS array.
      #
      # @param [Array<Integer>] inputs
      #   An array with all the membership functions of the system.
      # @return [Array<Integer>]
      #   Returns the membership function converted to CFS format.
      #
      def to_cfs(inputs = nil)
        cfs_data = Array.new

        # Get the output variable range.
        output_min = @variable.range_min
        output_max = @variable.range_max

        cfs_data.concat @constant.to_cfs(output_min, output_max)

        inputs.size.times do
          cfs_data.concat 0.to_cfs
        end

        return cfs_data
      end
    end
  end
end
