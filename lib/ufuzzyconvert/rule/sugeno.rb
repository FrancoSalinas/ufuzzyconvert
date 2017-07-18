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

    ##
    # Returns the range needed to fit the indpeendent term of a rule considering
    # that the coefficients may also need scaling.
    #
    # @param [Numeric] range_min
    #   Lower bound of the original variable range.
    # @param [Numeric] range_max
    #   Upper bound of the original variable range.
    # @param [Numeric] scale
    #   Minimum scaling needed to fit the other coefficients.
    # @return [Array<Numeric>] Returns an(output_min, output_max) pair.
    #
    def fit_independent_term(range_min, range_max, scale=1.0)

      # Get the input variables.
      inputs = @antecedent.map{|a| a.membership_function.variable}

      # Calculate the normalized independent term.
      _, normalized_term = @consequent.normalize(
        inputs, range_min, range_max
      )

      # Calculate its overflow.
      term_overflow = FixedPoint.overflow normalized_term

      # Calculate the most efficient anchor.
      anchor = term_overflow < 0 ? 0 : 1

      # If it does not overflow or the scale factor is greater than the
      # overflow.
      if term_overflow.abs <= 1 or term_overflow.abs <= scale
        # Then just widen the range using the scale factor.
        return scale_range range_min, range_max, scale
      # Else if there is a scale factor.
      elsif scale > 1
       # Then apply it in the most convenient way and try to fix the range
       # again.

        # Apply the scale.
        temp_min, temp_max = scale_range(
          range_min, range_max, scale, anchor
        )

        # Recalculate the independent term overflow using the new range. In
        # the new call scale==1 so this code is not executed again and the
        # maximum recursion depth is 1.
        return fit_independent_term temp_min, temp_max
      # Else if there isn't a scale factor.
      else
        # Then use the overflow to scale the range.

        # Given that the anchor is used, the scaling needed is only a half of
        # the overflow.
        return scale_range range_min, range_max, term_overflow.abs, anchor
      end
    end

    def scale_range(range_min, range_max, factor, anchor=0.5)
      increment = (range_max - range_min) * (factor - 1.0)
      return [
         range_min - increment * (1.0 - anchor),
         range_max + increment * anchor
      ]
    end

    ##
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
