module UFuzzyConvert

  require_relative '../rule'

  class SugenoRule < Rule

    require_relative '../t_norm'

    ##
    # Calculates the minimum and maximum values for an output variable.
    #
    def output_limits
      if @consequent.is_a UFuzzyConvert::MembershipFunction::Constant
        return @consequent.constant, @consequent.constant
      end

      # Get the input variables.
      inputs = @antecedent.map{|a| a.membership_function.variable}

      # Get the coefficients.
      coefficients = @consequent.coefficients

      # Calculate the minimum and the maximum output values.
      output_max = output_min = @consequent.independent_term
      inputs.zip(coefficients).each do |input, coefficient|
        limits = input.range_min * coefficient, input.range_max * coefficient

        output_min += limits.min
        output_max += limits.max
      end

      return output_min, output_max
    end

    # Converts a sugeno rule to CFS format.
    #
    # @return [Array<Integer>]
    #   Returns the rule converted to CFS format.
    #
    def to_cfs
      rule = Array.new

      if @connective.is_a? UFuzzyConvert::TNorm
        rule.push 0
      else
        rule.push 1
      end

      @antecedent.each do |antecedent|
        rule.push(*antecedent.to_cfs)
      end

      if rule.length & 1 != 0
        rule.push 0
      end

      inputs = @antecedent.map{|a| a.membership_function.variable}

      rule.concat @consequent.to_cfs(inputs)

      return rule
    end
  end
end
