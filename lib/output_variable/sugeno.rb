module UFuzzyConvert

  require_relative '../fuzzy_system'
  require_relative '../variable'

  class OutputVariable

    class Sugeno
      # @!attribute rules
      #   @return [Array<Rule::Sugeno>] Set of rules for this output.

      extend UFuzzyConvert::Variable

      #----------------------------[constants]---------------------------------#

      CFS_TYPE = 1

      #----------------------------[public class methods]----------------------#

      ##
      # Creates a Sugeno output variable from FIS data.
      #
      # @param [Hash] fis_data
      #   A parsed FIS.
      # @option fis_data [Hash<Int, Hash>] :outputs
      #   A hash with all the output variables parsed, where the key is the
      #   output variable index.
      # @option fis_data [Array<Hash>] :rules
      #   An array with all the rules parsed.
      # @param [Integer] index
      #   The index of the output variable to be parsed.
      # @return [OutputVariable::Sugeno]
      #   A new output variable object.
      # @raise [FeatureError]
      #  When a feature present in the FIS data is not supported.
      # @raise  [InputError]
      #  When the FIS data contains incomplete or erroneous information.
      #
      def self.from_fis_data(fis_data, index)
        outputs_section = fis_data.fetch(:outputs) {
          raise InputError.new, "Outputs section not defined."
        }

        output_data = outputs_section.fetch(index) {
          raise InputError.new, "Index not found."
        }

        range_min, range_max = range_from_fis_data output_data

        return Sugeno.new(
          range_min,
          range_max,
          Array.new
        )
      end

      #----------------------------[initialization]----------------------------#

      ##
      # Creates a mamdani output variable object.
      #
      # @param [Numeric] range_min
      #   The minimum value that the variable is able to take.
      # @param [Numeric] range_max
      #   The maximum value that the variable is able to take.
      # @param [Array<Rule::Sugeno>] rules
      #   Rules for this variable.
      # @raise [InputError]
      #   When range_min or range_max have invalid values.
      #
      def initialize(
        range_min,
        range_max,
        rules
      )
        if not range_min.is_a? Numeric
          raise InputError.new, "Range lower bound must be a number."
        end
        if not range_max.is_a? Numeric
          raise InputError.new, "Range upper bound must be a number."
        end
        if range_max <= range_min
          raise InputError.new, "Range bounds are swapped."
        end

        @range_min = range_min
        @range_max = range_max
        @rules = rules
      end

      #----------------------------[public methods]----------------------------#

      attr_accessor :rules

      ##
      # Converts an {OutputVariable} into a CFS array.
      #
      # @param [Hash<Symbol>] options
      #   Unused, but preserved to keep compatibility with other output
      #   variable types.
      # @return [Array<Integer>]
      #   Returns the output varaible converted to CFS format.
      # @raise  [InputError]
      #  When the FIS data contains incomplete or erroneous information.
      #
      def to_cfs(options)

        cfs_data = Array.new

        cfs_data.push CFS_TYPE
        cfs_data.push @rules.size

        rules.each do |rule|
          cfs_data.push(*rule.to_cfs(@range_min, @range_max))
        end

        return cfs_data
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end
  end

end
