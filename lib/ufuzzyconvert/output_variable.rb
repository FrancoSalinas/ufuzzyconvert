module UFuzzyConvert

  require_relative 'variable'

  class OutputVariable < Variable
    # @!attribute rules
    #   @return [Array<Rule>] Set of rules for this output.

    def initialize(range_min, range_max)
      super

      @rules = Array.new
    end

    def index
      return FuzzySystem.instance.output_index self
    end

    def membership_function_index(membership_function)
      index = @membership_functions.index membership_function

      if index.nil?
        raise ArgumentError, "The membership function does not belong to this "\
                             "output variable."
      else
        return index
      end
    end

    def rules
      return @rules.clone
    end

    def rules=(rules)
      @rules = rules.clone
    end

    private def rules_from_fis_data(
      rule_class, inputs, and_operator, or_operator, rules_data
    )
      rules = Array.new

      rules_data.each do |rule_data|
        rule = rule_class.from_fis_data(
          self, inputs, and_operator, or_operator, rule_data
        )
        if not rule.nil?
          rules.push rule
        end
      end

      return rules
    end
  end
end
