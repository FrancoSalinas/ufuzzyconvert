module UFuzzyConvert

  require_relative '../output_variable'

  class SugenoVariable < OutputVariable

    require_relative '../membership_function'
    require_relative '../rule/sugeno'

    CFS_TYPE = 1

    ##
    # Creates a Sugeno output variable from FIS data.
    #
    # @param [Hash] output_data
    #   A sugeno variable section parsed from a FIS file.
    # @param [Hash] system_data
    #   Unused.
    # @return [Sugeno]
    # @raise [InputError]
    #   When range_min or range_max have invalid values.
    #
    def self.from_fis_data(output_data, system_data)
      # May raise InputError.
      range_min, range_max = range_from_fis_data output_data

      return SugenoVariable.new(range_min, range_max)
    end

    def membership_functions=(membership_functions)

      membership_functions.each do |membership_function|
        if not membership_function.class == MembershipFunction::Linear
           not membership_function.class == MembershipFunction::Constant
          raise InputError.new, "Sugeno variables can only use linear or "\
                                "constant membership functions."
        end
      end

      super
    end

    def load_rules_from_fis_data(
      inputs, and_operator, or_operator, rules_data
    )
      @rules = rules_from_fis_data(
        SugenoRule,
        inputs,
        and_operator,
        or_operator,
        rules_data
      )
    end

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
        cfs_data.push(*rule.to_cfs)
      end

      return cfs_data
    end
  end
end
