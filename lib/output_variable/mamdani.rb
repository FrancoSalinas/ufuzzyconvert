module UFuzzyConvert

  require_relative '../output_variable'

  class MamdaniVariable < OutputVariable

    require_relative '../defuzzifier'
    require_relative '../membership_function'
    require_relative '../s_norm'
    require_relative '../t_norm'
    require_relative '../rule/mamdani'

    CFS_TYPE = 0

    ##
    # Creates a Mamdani output variable from FIS data.
    #
    # @param [Hash] output_data
    #   An output variable parsed from a mamdani FIS file.
    # @option output_data [Numeric] range_min
    #   The minimum value that the variable is able to take.
    # @option output_data [Numeric] range_max
    #   The maximum value that the variable is able to take.
    # @param [Hash] system_data
    # @option system_section [String] :AggMethod
    #   A string indicating the aggregation method to use.
    # @option system_section [String] :DefuzzMethod
    #   A string indicating the deffuzification method to use.
    # @option system_section [String] :ImpMethod
    #   A string indicating the operator implication method to use.
    # @return [MamdaniVariable]
    # @raise [InputError]
    #   When range_min or range_max have invalid values.
    #
    def self.from_fis_data(
      output_data,
      system_data
    )
      begin
        # May raise InputError.
        range_min, range_max = range_from_fis_data output_data

        # May raise InputError, FeatureError.
        activation_operator = activation_operator_from_fis_data system_data
        # May raise InputError, FeatureError.
        aggregation_operator = aggregation_operator_from_fis_data system_data
        # May raise InputError, FeatureError.
        defuzzifier = defuzzifier_from_fis_data system_data
      rescue UFuzzyError
        raise $!, "Output #{output_data[:index]}: #{$!}", $!.backtrace
      end

      return MamdaniVariable.new(
        range_min,
        range_max,
        activation_operator,
        aggregation_operator,
        defuzzifier
      )
    end

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
    # @raise [InputError]
    #   When range_min or range_max have invalid values.
    #
    def initialize(
      range_min,
      range_max,
      activation_operator,
      aggregation_operator,
      defuzzifier
    )
      # May raise InputError
      super(range_min, range_max)

      @activation_operator = activation_operator
      @aggregation_operator = aggregation_operator
      @defuzzifier = defuzzifier
    end

    def membership_functions=(membership_functions)

      membership_functions.each do |membership_function|
        if membership_function.class == MembershipFunction::Linear or
           membership_function.class == MembershipFunction::Constant
          raise InputError.new, "Mamdani variables cannot use linear nor "\
                                "constant membership functions."
        end
      end

      super
    end

    ##
    # Loads fuzzy rules from FIS data.
    #
    # This function iterates through the complete rule set and loads the rules
    # that affect this output.
    #
    # @param [Array<InputVariable>] inputs
    #   An array with all the system inputs.
    # @param [TNorm] and_operator
    # @param [SNorm] or_operator
    # @param [Array<Hash>] rules_data
    #   The parsed rules section of a FIS file.
    # @raise [FeatureError]
    #   When a feature present in the FIS data is not supported.
    # @raise  [InputError]
    #   When the FIS data contains incomplete or erroneous information.
    #
    def load_rules_from_fis_data(
      inputs, and_operator, or_operator, rules_data
    )
      @rules = rules_from_fis_data(
        MamdaniRule,
        inputs,
        and_operator,
        or_operator,
        rules_data
      )
    end

    ##
    # Converts an {OutputVariable} into a CFS array.
    #
    # @param [Hash] options
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
        cfs_data.push(*membership_function.to_cfs( options))
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

      if cfs_data.size & 1 == 1
        cfs_data.push 0
      end

      return cfs_data
    end

    ##
    # Creates the corresponding {SNorm} for the aggregation operator
    # defined in the givien FIS data.
    #
    # @param [Hash<Symbol>] system_section
    #   The parsed system section of a FIS file.
    # @option system_section [String] :AggMethod
    #   A string indicating the aggregation method to use.
    # @return [SNorm]
    #   A new {SNorm} object.
    # @raise  [InputError]
    #   When the `AggMethod` parameter is not given in the FIS data.
    # @raise  [FeatureError]
    #   When the `AggMethod` type is not recognized.
    #
    private_class_method def self.aggregation_operator_from_fis_data(
      system_section
    )

      operator_name = system_section.fetch(:AggMethod) {
        raise InputError.new, "AggMethod not defined."
      }

      # May raise FeatureError
      return SNorm.from_fis(operator_name)
    end

    ##
    # Creates a {Defuzzifier} object from FIS data.
    #
    # @param [Hash<Symbol>] system_section
    #   The parsed system section of a FIS file.
    # @option system_section [String] :DefuzzMethod
    #   A string indicating the defuzzification method to use.
    # @return [Defuzzifier]
    #   A new {Defuzzifier} object.
    # @raise  [InputError]
    #   When the `DefuzzMethod` parameter is not given in the FIS data.
    #
    private_class_method def self.defuzzifier_from_fis_data(system_section)

      defuzzifier_name = system_section.fetch(:DefuzzMethod) {
        raise InputError.new, "DefuzzMethod not defined."
      }

      return Defuzzifier.from_fis(defuzzifier_name)
    end

    ##
    # Creates the corresponding {TNorm} for the activation operator
    # defined in the givien FIS data.
    #
    # @param [Hash<Symbol>] system_section
    #   The parsed system section of a FIS file.
    # @option system_section [String] :ImpMethod
    #   A string indicating the implication method to use.
    # @return [TNorm]
    #   A new {TNorm} object.
    # @raise  [InputError]
    #   When the `ImpMethod` parameter is not given in the FIS data.
    # @raise  [FeatureError]
    #   When the `ImpMethod` type is not recognized.
    #
    private_class_method def self.activation_operator_from_fis_data(
      system_section
    )

      operator_name = system_section.fetch(:ImpMethod) {
        raise InputError.new, "ImpMethod not defined."
      }

      # May raise FeatureError
      return TNorm.from_fis(operator_name)
    end
  end
end
