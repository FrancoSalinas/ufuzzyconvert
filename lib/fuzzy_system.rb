module UFuzzyConvert

  require 'singleton'

  require_relative 'fis_parser'

  require_relative 'connective'
  require_relative 'defuzzifier'
  require_relative 'exception'
  require_relative 'input_variable'
  require_relative 'fixed_point'
  require_relative 'output_variable'
  require_relative 'output_variable_factory'
  require_relative 'proposition'
  require_relative 'rule'
  require_relative 's_norm'
  require_relative 't_norm'

  class FuzzySystem

    include Singleton

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
        raise InputError.new, e.message, e.backtrace
      end

      fuzzy_system = FuzzySystem.instance

      fuzzy_system.and_operator = and_operator_from_fis_data fis_data
      fuzzy_system.or_operator = or_operator_from_fis_data fis_data
      fuzzy_system.load_variables_from_fis_data fis_data

      return fuzzy_system
    end

    #----------------------------[initialization]------------------------------#

    ##
    # Creates a {FuzzySystem} object.
    #
    # @param [TNorm] and_operator
    #   The AND operator.
    # @param [SNorm] or_operator
    #   The OR operator.
    #
    def initialize
      @inputs = Array.new
      @outputs = Array.new
    end

    #----------------------------[public methods]------------------------------#

    attr_accessor :and_operator
    attr_accessor :or_operator

    def output_index(output)
      index = @outputs.index output

      if index.nil?
        raise ArgumentError, "The output variable does not belong to the "\
                             "system."
      else
        return index + 1
      end
    end

    def load_variables_from_fis_data(fis_data)
      load_inputs_from_fis_data(fis_data)
      load_outputs_from_fis_data(fis_data)
    end

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

      cfs_data = ['C'.ord, 'F'.ord, 'S'.ord, 0]

      cfs_data.push(*@and_operator.to_cfs)
      cfs_data.push(*@or_operator.to_cfs)
      cfs_data.push(@inputs.length)
      cfs_data.push(@outputs.length)

      cfs_data.push(*variables_to_cfs(@inputs, options))
      cfs_data.push(*variables_to_cfs(@outputs, options))

      return cfs_data
    end

    #----------------------------[private class methods]-----------------------#

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
    private_class_method def self.and_operator_from_fis_data(fis_data)
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
    private_class_method def self.or_operator_from_fis_data(fis_data)
      if not fis_data.key? :system
        raise InputError.new, "System section not defined."
      end

      if not fis_data[:system].key? :OrMethod
        raise InputError.new, "OrMethod not defined."
      end

      # May raise FeatureError
      return SNorm.from_fis(fis_data[:system][:OrMethod])
    end

    #----------------------------[private methods]-----------------------------#

    private def load_inputs_from_fis_data(fis_data)
      @inputs = Array.new
      unless fis_data[:inputs].nil?
        fis_data[:inputs].each do |index, input_data|
          input = InputVariable.from_fis_data(input_data)
          @inputs.push input

          input.load_membership_functions_from_fis_data input_data
        end
      end
    end

    private def load_outputs_from_fis_data(fis_data)
      @outputs = Array.new

      if fis_data[:outputs].nil? or fis_data[:outputs].length == 0
        raise InputError.new, "At least one output variable is required."
      end

      if fis_data[:rules].nil?
        raise InputError.new, "Rules section not defined."
      end

      fis_data[:outputs].each do |index, output_data|
        output = OutputVariableFactory.from_fis_data(
          output_data, fis_data[:system]
        )
        @outputs.push output

        output.load_membership_functions_from_fis_data(output_data)
        output.load_rules_from_fis_data(
          @inputs,
          @and_operator,
          @or_operator,
          fis_data[:rules]
        )
      end
    end

    private def variables_to_cfs(variables, options)
      cfs_data = Array.new

      variables.each do |variable|
        cfs_data.concat variable.to_cfs(options)
      end
      return cfs_data
    end

  end

end
