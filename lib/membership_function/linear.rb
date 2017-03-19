module UFuzzyConvert

  require_relative '../exception'
  require_relative '../fixed_point'
  require_relative '../output_variable/sugeno'

  module MembershipFunction

    require_relative 'base'

    ##
    # Class used to represent any membership function.
    #
    # This class is used by {Proposition} to represent a proposition that does
    # not affect a variable, i.e. 'INPUT IS ANY'
    #
    class Linear < Base

      ##
      # Creates a linear membership function.
      #
      # @param [SugenoVariable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] a
      #   x-coordinate where the slope starts.
      # @param [Numeric] b
      #   x-coordinate where the slope ends.
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When a or b have invalid values.
      #
      def initialize(variable, coefficients, name = "")
        super(variable)

        coefficients.each do |c|
          if not c.is_a? Numeric
            raise InputError.new, "Parameters must be numeric."
          end
        end

        @name = name
        @independent_term = coefficients.last
        @coefficients = coefficients[0..-2].map{|c| c.to_f}
      end

      ##
      # Converts the membership function into a CFS array.
      #
      # @param [Array<Integer>] inputs
      #   An array with all the membership functions of the system.
      # @return [Array<Integer>]
      #   Returns the membership function converted to CFS format.
      #
      def to_cfs(inputs)

          if @coefficients.size != inputs.size
          	raise InputError.new, "The number of coefficients does not match "\
                                  "the number of input variables."
          end

        cfs_data = Array.new

        # Get the output variable range.
        output_min = @variable.range_min
        output_max = @variable.range_max

        output_delta = output_max - output_min

      	# All the coefficients must be normalized considering the original
        # range of the input and output variables
      	#
      	# The coefficient Ak for the input variable Ik is normalized like:
      	#
      	# Ak' = Ak * delta(Ik) / delta(O)
      	#
      	# where delta(Ik) = Ikmax - Imin and delta(O) = Omax - Omin
      	#
      	# The coefficient A0 or the independent term is calculated as follows:
      	#
      	# A0' = (sum(Ak*Ikmin)/delta(0) + (A0-Omin)/delta(O))
      	#

      	normalized_independent_term = @independent_term
        normalized_coefficients = Array.new

        @coefficients.zip(inputs).each do |coefficient, input|

      		input_min = input.range_min
      		input_delta = input.range_max - input_min

      		# Push the coefficient into the array.
      		normalized_coefficients.push(
            coefficient * input_delta / output_delta
          )

      		# Add to the independent term the part which depends of this input
          # variable range and coefficient.
      		normalized_independent_term += coefficient * input_min
      	end

        begin
      	   cfs_data.concat normalized_independent_term.to_cfs(
            output_min, output_max
          )
        rescue InputError
          raise $!, "Independent term: #{$!}", $!.backtrace
        end

        normalized_coefficients.each_with_index do |coefficient, i|
          begin
        	  cfs_data.concat coefficient.to_cfs
          rescue InputError
            raise $!, "Coefficient #{i} term: #{$!}", $!.backtrace
          end
        end

        return cfs_data
      end
    end
  end
end
