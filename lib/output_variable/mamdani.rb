module UFuzzyConvert

  require_relative '../fuzzy_system'
  require_relative '../rule'
  require_relative '../variable'

  class OutputVariable

    class Mamdani
      # @!attribute rules
      #   @return [Array<MamdaniRule>] Set of rules for this output.

      extend UFuzzyConvert::Variable

      #----------------------------[constants]---------------------------------#

      CFS_TYPE = 0

      #----------------------------[public class methods]----------------------#

      ##
      # Creates a Mamdani output variable from FIS data.
      #
      # @param [Hash] fis_data
      #   A parsed FIS.
      # @option fis_data [Hash] :system
      #   The System section parsed.
      # @option fis_data [Hash<Int, Hash>] :outputs
      #   A hash with all the output variables parsed, where the key is the
      #   output variable index.
      # @option fis_data [Array<Hash>] :rules
      #   An array with all the rules parsed.
      # @param [Integer] index
      #   The index of the output variable to be parsed.
      # @return [OutputVariable::Mamdani]
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

        system_section = fis_data.fetch(:system) {
          raise InputError.new, "System section not defined."
        }

        output_data = outputs_section.fetch(index) {
          raise InputError.new, "Index not found."
        }

        range_min, range_max = range_from_fis_data output_data
        activation_operator = FuzzySystem.activation_operator_from_fis_data(
          system_section
        )
        aggregation_operator = FuzzySystem.aggregation_operator_from_fis_data(
          system_section
        )
        defuzzifier = FuzzySystem.defuzzifier_from_fis_data system_section

        return Mamdani.new(
          range_min,
          range_max,
          activation_operator,
          aggregation_operator,
          defuzzifier,
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
      # @param [TNorm] activation_operator
      #   The activation operator.
      # @param [SNorm] aggregation_operator
      #   The aggregation operator.
      # @param [Defuzzifier] defuzzifier
      #   The defuzzification method.
      # @param [Array<InputVariable>] membership_functions
      #   Membership functions for this variable.
      # @param [Array<Rule::Mamdani>] rules
      #   Rules for this variable.
      # @raise [InputError]
      #   When range_min or range_max have invalid values.
      #
      def initialize(
        range_min,
        range_max,
        activation_operator,
        aggregation_operator,
        defuzzifier,
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
        @activation_operator = activation_operator
        @aggregation_operator = aggregation_operator
        @defuzzifier = defuzzifier
        @rules = rules
      end

      #----------------------------[public methods]----------------------------#

      attr_accessor :rules

      ##
      # Converts an {OutputVariable} into a CFS array.
      #
      # @param [Hash<Symbol>] options
      # @option options [Integer] :dsteps
      #   Base 2 logarithm of the number of defuzzification steps to be
      #   performed.
      # @option options [Integer] :tsize
      #   Base 2 logarithm of the number of entries in a tabulated membership
      #   function.
      # @return [Array<Integer>]
      #   Returns the output varaible converted to CFS format.
      # @raise  [InputError]
      #  When the FIS data contains incomplete or erroneous information.
      #
      def to_cfs(options)

        log2_defuzzification_steps = options.fetch(:dsteps) {
          raise InputError.new, "Defuzzification steps not defined."
        }

        cfs_data = Array.new

        cfs_data.push(CFS_TYPE)
        cfs_data.push(@membership_functions.size)

        @membership_functions.each do |membership_function|
          cfs_data.push(
            *membership_function.to_cfs(@range_min, @range_max, options)
          )
        end

        cfs_data.push(*@activation_operator.to_cfs)
        cfs_data.push(*@aggregation_operator.to_cfs)
        cfs_data.push(*@defuzzifier.to_cfs)
        cfs_data.push log2_defuzzification_steps
        cfs_data.push 0
        cfs_data.push @rules.size

        rules.each do |rule|
          cfs_data.push(*rule.to_cfs)
        end

        return cfs_data
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end
  end

end
