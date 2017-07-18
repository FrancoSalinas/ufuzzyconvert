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

    ##
    # Returns a number indicating how much a Sugeno coefficient overflows the
    # range of values that can be represented used fixed point variables.
    # This number is calculated as `delta R' / delta R` where R' is the range
    # needed to represent the coefficient with the biggest overflow, and R is
    # the current range. If a coefficient cannot be represented, its absolute
    # value is greater than 1.0.
    #
    def coefficient_overflow(range_min, range_max)
      # Get the input variables.
      inputs = @antecedent.map{|a| a.membership_function.variable}

      # Normalize the coefficients.
      normalized_coefficients, _ = @consequent.normalize(
        inputs, range_min, range_max
      )

      minimum = FixedPoint.overflow normalized_coefficients.min
      maximum = FixedPoint.overflow normalized_coefficients.max

      return minimum.abs > maximum.abs ? minimum : maximum
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
