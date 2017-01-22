module UFuzzyConvert

  require_relative 'fis_parser'

  require_relative 'connective'
  require_relative 'defuzzifier'
  require_relative 'exception'
  require_relative 'input_variable'
  require_relative 'fixed_point'
  require_relative 'output_variable'
  require_relative 'proposition'
  require_relative 's_norm'
  require_relative 't_norm'

  class FuzzySystem

    #----------------------------[constants]-----------------------------------#

    #----------------------------[public class methods]------------------------#

    ##
    # Creates a {FuzzySystem} object from a FIS string.
    #
    # @param [String] fis_str
    #   The contents of a FIS file.
    # @return [FuzzySystem]
    #   A new {FuzzySystem} object.
    # @raise [FeatureError]
    #  When a feature present in the FIS data is not supported.
    # @raise  [InputError]
    #  When the FIS data contains incomplete or erroneous information.
    #
    def self.from_fis(fis_str)
      begin
        fis_data = Parser.parse(fis_str)
      rescue Exception => e
        raise InputError.new, e.message
      end

      and_operator = and_operator_from_fis_data fis_data
      or_operator = or_operator_from_fis_data fis_data
      inputs = inputs_from_fis_data fis_data
      outputs = outputs_from_fis_data fis_data

      return FuzzySystem.new and_operator, or_operator, inputs, outputs
    end

    ##
    # Creates the corresponding {TNorm} for the activation operator
    # defined in the givien FIS data.
    #
    # @param [Hash<Symbol>] system_section
    #   The parsed system section of a FIS file.
    # @option system_section [String] :ImpMethod
    #   A string indicating the operator to use.
    # @return [TNorm]
    #   A new {TNorm} object.
    # @raise  [InputError]
    #   When the `ImpMethod` parameter is not given in the FIS data.
    # @raise  [FeatureError]
    #   When the `ImpMethod` type is not recognized.
    #
    def self.activation_operator_from_fis_data(system_section)

      operator_name = system_section.fetch(:ImpMethod) {
        raise InputError.new, "ImpMethod not defined."
      }

      # May raise FeatureError
      return TNorm.from_fis(operator_name)
    end

    ##
    # Creates the corresponding {SNorm} for the aggregation operator
    # defined in the givien FIS data.
    #
    # @param [Hash<Symbol>] system_section
    #   The parsed system section of a FIS file.
    # @option system_section [String] :AggMethod
    #   A string indicating the operator to use.
    # @return [SNorm]
    #   A new {SNorm} object.
    # @raise  [InputError]
    #   When the `AggMethod` parameter is not given in the FIS data.
    # @raise  [FeatureError]
    #   When the `AggMethod` type is not recognized.
    #
    def self.aggregation_operator_from_fis_data(system_section)

      operator_name = system_section.fetch(:AggMethod) {
        raise InputError.new, "AggMethod not defined."
      }

      # May raise FeatureError
      return SNorm.from_fis(operator_name)
    end

    ##
    # Creates the corresponding {TNorm} for the AND operator
    # defined in the givien FIS data.
    #
    # @param [Hash<Symbol>] system_section
    #   The parsed system section of a FIS file.
    # @option system_section [String] :AndMethod
    #   A string indicating the operator to use.
    # @return [TNorm]
    #   A new {TNorm} object.
    # @raise  [InputError]
    #   When the `AndMethod` parameter is not given in the FIS data.
    # @raise  [FeatureError]
    #   When the `AndMethod` type is not recognized.
    #
    def self.and_operator_from_fis_data(fis_data)
      if not fis_data.key? :system
        raise InputError.new, "System section not defined."
      end

      if not fis_data[:system].key? :AndMethod
        raise InputError.new, "AndMethod not defined."
      end

      # May raise FeatureError
      return TNorm.from_fis(fis_data[:system][:AndMethod])
    end

    ##
    # Creates the corresponding {SNorm} for the OR operator
    # defined in the givien FIS data.
    #
    # @param [Hash<Symbol>] system_section
    #   The parsed system section of a FIS file.
    # @option system_section [String] :OrMethod
    #   A string indicating the operator to use.
    # @return [SNorm]
    #   A new {SNorm} object.
    # @raise  [InputError]
    #   When the `OrMethod` parameter is not given in the FIS data.
    # @raise  [FeatureError]
    #   When the `OrMethod` type is not recognized.
    #
    def or_operator_from_fis_data(fis_data)
      if not fis_data.key? :system
        raise InputError.new, "System section not defined."
      end

      if not fis_data[:system].key? :OrMethod
        raise InputError.new, "OrMethod not defined."
      end

      # May raise FeatureError
      return SNorm.from_fis(fis_data[:system][:OrMethod])
    end

    ##
    # Creates a {Defuzzifier} object from FIS data.
    #
    # @param [Hash<Symbol>] system_section
    #   The parsed system section of a FIS file.
    # @option system_section [String] :DefuzzMethod
    #   A string indicating the method to use.
    # @return [Defuzzifier]
    #   A new {Defuzzifier} object.
    # @raise  [InputError]
    #   When the `DefuzzMethod` parameter is not given in the FIS data.
    #
    def self.defuzzifier_from_fis_data(system_section)

      defuzzifier_name = system_section.fetch(:DefuzzMethod) {
        raise InputError.new, "DefuzzMethod not defined."
      }

      return Defuzzifier.from_fis(defuzzifier_name)
    end

    #----------------------------[initialization]------------------------------#

    ##
    # Creates a {FuzzySystem} object.
    #
    # @param [TNorm] and_operator
    #   The AND operator.
    # @param [SNorm] or_operator
    #   The OR operator.
    # @param [Array<InputVariable>] inputs
    #   Input variables of the system.
    # @param [Array<OutputVariable>] outputs
    #   Output variables of the system.
    #
    def initialize(and_operator, or_operator, inputs, outputs)
      @and_operator = and_operator
      @or_operator = or_operator
      @inputs = inputs
      @outputs = outputs
    end

    #----------------------------[public methods]------------------------------#

    ##
    # Converts a {FuzzySystem} into a CFS array.
    #
    # @param [Hash<Symbol>] options
    # @option options [Integer] :dsteps
    #   Base 2 logarithm of the number of defuzzification steps to be performed.
    # @option options [Integer] :tsize
    #   Base 2 logarithm of the number of entries in a tabulated membership
    #   function.
    # @return [Array<Integer>]
    #   Returns the fuzzy system converted to CFS format.
    # @raise [FeatureError]
    #  When a feature present in the FIS data is not supported.
    # @raise  [InputError]
    #  When the FIS data contains incomplete or erroneous information.
    #
    def to_cfs(options = {
        :dsteps => 8,
        :tsize => 8
      })

      cfs_data = ['C', 'F', 'S', 0]

      cfs_data.push(*@and_operator.to_cfs)
      cfs_data.push(*@or_operator.to_cfs)
      cfs_data.push(@inputs.length)
      cfs_data.push(@outputs.length)

      cfs_data.push(*variables_to_cfs(@inputs, options))
      cfs_data.push(*variables_to_cfs(@outputs, options))

      return cfs_data
    end

    #----------------------------[private class methods]-----------------------#

    class << self

      def inputs_from_fis_data(fis_data)
        inputs = Array.new

        unless fis_data[:inputs].nil?
          fis_data[:inputs].each do |index, input_data|
            input = InputVariable.from_fis_data(input_data)

            input.membership_functions_from_fis_data(
              input_data
            )

            inputs.push input
          end
        end

        return inputs
      end

      def outputs_from_fis_data(fis_data)
        outputs = Array.new

        if fis_data[:outputs].nil? or fis_data[:outputs].length == 0
          raise InputError.new, "At least one output variable is required."
        end

        fis_data[:outputs].each do |index, output_data|
          outputs.push OutputVariable.from_fis_data fis_data, index
        end

        return outputs
      end
    end

    #----------------------------[private methods]-----------------------------#

    private

    def variables_to_cfs(variables, options)
      cfs_data = Array.new
      variables.each do |variable|
        cfs_data.push(*variable.to_cfs(options))
      end
      return cfs_data
    end

  end

end
